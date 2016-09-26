#!/usr/bin/env ruby
require "sinatra"
require "open3"

if ARGV[0] == "onboot"
  if File.realpath("/sbin/init") != "/sbin/init" then
    File.open("/etc/init/dokku-installer.conf", "w") do |f|
      f.puts "start on runlevel [2345]"
      f.puts "exec #{File.absolute_path(__FILE__)} selfdestruct"
    end if File.directory?("/etc/init")
    File.open("/etc/systemd/system/dokku-installer.service", "w") do |f|
      f.puts "[Unit]"
      f.puts "Description=Dokku web-installer"
      f.puts ""
      f.puts "[Service]"
      f.puts "ExecStart=#{File.absolute_path(__FILE__)} selfdestruct"
      f.puts ""
      f.puts "[Install]"
      f.puts "WantedBy=multi-user.target"
      f.puts "WantedBy=graphical.target"
    end if File.directory?("/etc/systemd/system")
  else
    FileUtils.cp(File.absolute_path(__FILE__)+"init", "/etc/init.d/dokku-installer", options)
    `update-rc.d -f dokku-installer defaults`
  end
  File.open("/etc/nginx/conf.d/dokku-installer.conf", "w") do |f|
    f.puts "upstream dokku-installer { server 127.0.0.1:2000; }"
    f.puts "server {"
      f.puts "  listen      80;"
      f.puts "  location    / {"
      f.puts "    proxy_pass  http://dokku-installer;"
      f.puts "  }"
    f.puts "}"
  end
  `rm -f /etc/nginx/sites-enabled/*`
  puts "Installed Upstart/Systemd/SysV-init service and default Nginx virtualhost for installer to run on boot."
  exit
end

version = `cat /var/lib/dokku-alt/VERSION`.split("\n").first
dokku_root  = ENV["DOKKU_ROOT"] || "/home/dokku"
admin_keys  = `cat /root/.ssh/authorized_keys`.split("\n")
hostname  = `bash -c '[[ $(dig +short $HOSTNAME) ]] && echo $HOSTNAME || curl icanhazip.com'`.strip
template  = DATA.read

set :port, 2000
set :environment, :production
disable :protection

get "/" do
  ERB.new(template).result binding
end

post "/setup" do
  if params[:vhost] == "true"
    File.open("#{dokku_root}/VHOST", "w") {|f| f.write params[:hostname] }
  else
    `rm #{dokku_root}/VHOST`
  end
  File.open("#{dokku_root}/HOSTNAME", "w") {|f| f.write params[:hostname] }
  keys = params[:keys].split("\n")
  keys.each do |k|
    Open3.capture2("sshcommand acl-add dokku admin", :stdin_data => k)
  end
  Thread.new {
    `rm /etc/nginx/conf.d/dokku-installer.conf && /etc/init.d/nginx stop && /etc/init.d/nginx start`
    `rm -f /etc/init/dokku-installer.conf /etc/systemd/system/dokku-installer.service && stop dokku-installer`
  }.run if ARGV[0] == "selfdestruct"
end

__END__
<html>
<head>
  <title>Dokku Setup</title>
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" />
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
</head>
<body>
  <div class="container" style="width: 640px;">
  <form id="form" role="form">
    <h1>Dokku Setup <small><%= version %></small></h1>
    <div class="form-group">
      <h3><small style="text-transform: uppercase;">Admin Access</small></h3>
      <label for="key">Public Key</label><br />
      <textarea class="form-control" name="keys" rows="7" id="key"><% admin_keys.each do |key| %><%= key + "\n" %><% end %></textarea>
    </div>
    <div class="form-group">
      <h3><small style="text-transform: uppercase;">Hostname Configuration</small></h3>
      <div class="form-group">
        <label for="hostname">Hostname</label>
        <input class="form-control" type="text" id="hostname" name="hostname" value="<%= hostname %>" />
      </div>
      <div class="checkbox">
        <label><input id="vhost" name="vhost" type="checkbox" value="true"> Use <abbr title="Nginx will be run on port 80 and backend to your apps based on hostname">virtualhost naming</abbr> for apps</label>
      </div>
      <p>Your app URLs will look like:</p>
      <pre id="example">http://hostname:port</pre>
    </div>
    <button type="button" onclick="setup()" class="btn btn-primary">Finish Setup</button> <span style="padding-left: 20px;" id="result"></span>
  </form>
  </div>
  <div id="error-output"></div>
  <script>
    function setup() {
      if ($.trim($("#key").val()) == "") {
        alert("Your admin public key cannot be blank.")
        return
      }
      if ($.trim($("#hostname").val()) == "") {
        alert("Your hostname cannot be blank.")
        return
      }
      data = $("#form").serialize()
      $("input,textarea,button").prop("disabled", true);
      $.post('/setup', data)
        .done(function() {
          $("#result").html("Success!")
          window.location.href = "http://progrium.viewdocs.io/dokku/application-deployment";
        })
        .fail(function(data) {
          $("#result").html("Something went wrong...")
          $("#error-output").html(data.responseText)
        });
    }
    function update() {
      if ($("#vhost").is(":checked") && $("#hostname").val().match(/^(\d{1,3}\.){3}\d{1,3}$/)) {
        alert("In order to use virtualhost naming, the hostname must not be an IP but a valid domain name.")
        $("#vhost").prop('checked', false);
      }
      if ($("#vhost").is(':checked')) {
        $("#example").html("http://&lt;app-name&gt;."+$("#hostname").val())
      } else {
        $("#example").html("http://"+$("#hostname").val()+":&lt;app-port&gt;")
      }
    }
    $("#vhost").change(update);
    $("#hostname").change(update);
    update();
  </script>
</body>
</html>

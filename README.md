# Docker Build Scripts

This repository will provide various Dockerfiles for building images as used in hosting environments.

## Postgresql 9.1 Server
**Build Image:**  
`docker build -t pgsql pgsql`

**Run with:**  
`docker run -p 5432 -d pgsql /usr/bin/start_pgsql.sh YOURPASSWORDHERE`

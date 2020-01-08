# docker_jenkins_lts
Dockerized jenkins

Find initial password for jenkins
`
docker exec <container_name> cat /var/jenkins_home/secrets/initialAdminPassword
`

$ docker-compose logs jenkins
Attaching to jenkins
jenkins    | Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?
jenkins    | touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied

$ sudo chown -R 1000 /data/jenkins/

Permission Denied
1. Log into the jenkins container as root
'> docker exec -it --user root jenkins bash`
2. Grant full permission to docker uds socket 
`> chmod 777 /var/run/docker.sock`

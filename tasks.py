from invoke import task, run
from jenkinsapi.jenkins import Jenkins
import tarfile
import time

def restore(file_name, dest="/var/lib/jenkins"):
    
    print "Restoring Jenkins Backup..."
    file_name = "/jenkins_backup/" + file_name
    with tarfile.open(file_name, "r:gz") as tar:
        tar.extractall(dest)
    
    print "Restore Done!"


@task
def run_backup(file_name, jenkins_home):

    print "Backuping Jenkins..."
    
    file_name = "/jenkins_backup/" + file_name

    with tarfile.open(file_name, "w:gz") as tar:
        tar.add(jenkins_home, arcname='.')
    
    print "Backup Done!"

@task 
def restore_run(file_name):    
    restore(file_name)
    
    run("sudo service jenkins start && /bin/bash")


@task
def restore_validate(file_name):
    restore(file_name)
    
    run("sudo service jenkins start")    
    print "Waiting for API..."
    time.sleep(25)

    print "Checking jobs..."
    jenkins_url = "http://localhost:8080"
    server = Jenkins(jenkins_url, username='admin', password='admin')
      
    for job_name, job_instance in server.get_jobs():
        print 'Job Name:%s' % (job_instance.name)   
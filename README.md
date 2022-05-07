# sample-may
#### This is a sample project create for the DevOps CI-CD pipeline session.
This code is is being generated using `mvn archetype:generate -DgroupId=com.thinknyx.kul -DartifactId=boa-may -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false`
#### commands to create maven package
`mvn clean package`
#### working with the branches
- List local branches `git branch`
- For remote branches `git branch -r`
- For all branches `git branch -`
#### create branch from other than current branch or revision using git bash
- `git branch new-branch-name source-branch-name`
- `git branch new-branch-name e360cea`
#### command to delete the branch
- `git branch -d branch-name`
- `git branch -D branch-name` to delete the branch which contains the unmerged changes
#### you can't delete the current branch
#### Stash 
- `git stash`
- `git stash pop`
#### new commit after repository cloned to local system
- `git clone https://github.com/kul-boa/sample-may.git`
#### adding some text to check SCM Polling Build Trigger in Jenkins
#### created new branch for build trigger demo in jenkins

Prerequisites: have docker installed

Tested only on linux.

Installatione part:

1) CD into the folder containing the desired version (more version will be added)
2) built the image using the following command
- docker build -t [name of your image] .
3) Run a container using:
- docker run -dit -p8080:8080 [name of your image]
this will create and start a new container
4) Resolve the distribution wisard 
5) Save the state of your image after the distribution wisard with
- docker commit [id of the container] [tag]


Usage:

run/start/stop

The run command will alwais create a new container, so whenever you need a new fresh instance use:
- docker run -dit -p8080:8080 [name of your image]

Stop the container with:
- docker stop [container name]

this will stop the container but the work you did inside it is kept and you can restart and continue from where you left off.

Check the list of existing containers:
- docker ps -a

Start a previous container
- docker start [container name]

test

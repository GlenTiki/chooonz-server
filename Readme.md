# The chooonz-server boii!

This is an assignment by Glen Keane (20057974) submitted for Mac Development.

This is my first foray into server side Swift, using [Kitura](https://github.com/IBM-Swift/Kitura) as a framework, and deployed onto [Bluemix](bluemix.net).

This is a WebService which lists popular Irish music, to be used by a front end application developed by another student. The idea of this project was that between the two students who were taking the class, one would develop the front end, and the other the backend (Me).

## Full Stack Swift. It works.

### What was done?

A server was built in swift and deployed to the IBM Bluemix cloud which serves us data. It is available on the web [here](http://choonz.eu-gb.bluemix.net)

This includes http routes to get all songs, get a song by id, and get a song's image.

To get all songs go to `/songs`.

To get a song by id go to `/songs/{id}` where `{id}` is the song's id.

To get a songs image go to `/songs/{id}/image` where `{id}` is the id of the song who's image you want to retrieve.

The id of the song is provided in the `/songs` data.

Additionally, because this service only sends the song data, I make the index route, `/`, redirect to `/songs`.

### Why is this interesting?

This is server side swift. It is pushing the boundaries on a language which was developed primarily for application development on IOS.

Kitura, the framework which was used, is a really nice way of writing server side application, and appears to take a lot of inspiration from the popular [expressjs](http://expressjs.com), Node.js server side framework. As an experienced Node.js developer, this felt familiar to me. However, this has the benefit of being a compiled language, so it _should_ be faster and _more_ memory efficient than Node.js, as Node.js requires an embedded Javascript interpreter and compiler (V8).

### How did all of this come to be?

First, I investigated Swift on the Serverside, and discovered that _bluemix_ by IBM give you a really nice set of deployment tools for putting Swift on the server. Or at least, that's what I read.

After finding this and mentioned to my lecturer that I would love the chance to work on a project with it, he then came up with the idea for this project, allowing myself to focus on Serverside and the other student taking this class to focus on Frontend.

So, I investigated Kitura, and using the [TodoList Example](https://github.com/IBM-Swift/Kitura/wiki/Build-a-To-do-List-Backend), I put together this project which serves up some data defined in `data.json`.

Then I deployed this to Bluemix. I had a lot of trouble getting this project onto Bluemix, because the version of Kitura that this application was developed with (version 13) required a version of Swift which was unsupported on Bluemix. To get around this issue, I investigated deploying to Bluemix using Docker containers (which I got working!) or using a different 'buildpack' on Bluemix, which supported the newer version of swift I needed to use. After talking to some of the Kitura devs on [Gitter](https://gitter.im/IBM-Swift/Kitura), I was pointed toward a [buildpack](https://github.com/IBM-Swift/swift-buildpack) that would work on Bluemix and I was able to use that for deployment.

Deployment is as simple as pushing the code in this git repo to a git repo hosted on Bluemix. Bluemix compiles and deploys the code to the cloud using the buildpack I have defined at the bottom of the [manifest file](./manifest.yml)

### Some Caveats

Serverside Swift is not without its growing pains.

The big issue with this project was that I didn't hook it up to a database, all data which it serves is provided in the `data.json` file. There is code for adding, modifying and deleting song data, but you cannot upload images here or persist that data if the server goes down, etc. The lack of very well documented database connectors was what lead me to not use one for this project, although they are available.

To deploy this project locally, I would recommend using Docker, as it seems to provide the most stable environment for deploying. However, Instructions have been provided in detail below on how to deploy this without Docker.

## Local deployment and Development

To deploy this project locally, it is recommended that [Docker](https://www.docker.com) is used. Docker enables the project to be nicely containerized for deployment, meaning the deployment environment is much more stable. However, instructions are provided on running without Docker.

### Docker

First, ensure docker is installed and setup, and you have an IP on which you can access your docker-machine, if on Mac or Windows. Older versions of docker allowed you to access the machine on localhost, but I discovered I needed to use a specific IP to access it this time around, to retrieve the IP, I ran the following:

```
docker-machine ls
docker-machine ip default
```

The second command gives me the IP I can access my containers at.

To build and run this as a docker container, you must run the following commands:

```
docker build -t chooonz .
docker run --name chooonz -d -p 8090:8090 -t chooonz
```

This tells docker to use the attached Dockerfile within this repo to build the code in this project and then run it, mapping the port 8090 publically.

### Without Dockerfile

First, you must have a specific development snapshot of Swift installed on your machine, which can be downloaded from [here](https://swift.org/download/#snapshots)

The version required was released May 3rd, 2016, on the development branch.

After downloading and installing that snapshot, you can open a terminal session and open this repository. With this repo open in you terminal you should be just able to run the following commands to build and run this service:

```
Make build
Make run
```

The service should now be available at localhost:8090.

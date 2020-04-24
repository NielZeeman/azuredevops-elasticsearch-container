# Install Azure DevOps Server Elastic Search into a Docker Image

This is a test to see if it is possible. Turns out it does work 😊.

## What this does
This creates an image based on the windowsservercode image. It then installs Azul Zulu Java (per [this](https://github.com/microsoft/Code-Search/blob/master/Java%20Migration/Azure_DevOps_Server_2019.md) guide] ).
It then configures the elastic search service installing the Azure DevOps extensions.


## Get Started
1. Clone this repository
2. From the search directory of the Azure DevOps Server (default "C:\Program Files\Azure DevOps Server 2019\Search\") copy the "zip" folder to the cloned directory
3. Run ```docker build --build-arg ES_USER=youresuser --build-arg ES_PASS=yourespass --pull --rm -t azuredevopselastic:latest "."``` (see known issues below)

After the image is built, you can run it and [configure](https://docs.microsoft.com/en-us/azure/devops/project/search/administration?view=azure-devops-2019#separate-server) Azure DevOps Server's search to point to the containers external IP and port.

To run the image, you can simply do something like this:
```docker run -p 9200:9200 azuredevopselastic```

You may want to map the data directories to a persistent store, and while you at it the logs are also helpful.
So you may try this:

```docker run -ti -v C:\persistent\local\data:c:\work\ESDATA -v C:\persistent\local\logs:c:\work\ES\elasticsearchv5\logs -p 9200:9200 azuredevopselastic``` 

## Issues

### Takes long to build
The Azul Zulu JDK is downloaded directly everytime it is built. You may want to change this by downloading it once and copying it into the image instead.

### Get-NetFirewallProfile : There are no more endpoints available from the endpoint mapper. 

This error occurs when the image is being built. The configuration makes a call to ```Get-NetFirewallProfile```. This obviously does not play well in a docker image, but it does not seem to cause any harm, It merely displays some information.

### log4j2.properties
There is a custom log4j2.properties file that is copied over the customised file that is eventually copied to the elasticsearch install directory. Once again, the original required a console logger that does not seem to be present. It does still log to the log files; hence it may be a good idea to map the log folder (as indicated above).

## Finally
Any feedback welcome..

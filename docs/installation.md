# How to Install the Application

---

## Opening the Project

The [WebApp](/WebApp) folder is an Eclipse Project. You can import it to Eclipse and utilize it as any other project. If you have Apache Tomcat installed (refer to [dependencies](/docs/dependencies.md)) you may run the project as a web project. You should now be able to see the main page (UI) of the application. Note that no option will be working while the other tools are not installed (libraries/jars).

## Adding JARs to the Project

For the tools to work properly with the web application, the following libraries must be added to the project. Note that without executing the tools (refer to [how to run](/docs/run.md)) the web application will still note function. With that being said, the necessary JARs are the following:

- All JARs provided by Hadoop
- All JARs provided by Kafka
- All JARs provided by Avro
- All JARs provided by Mahout
- All JARs provided by JSON simple

>**NOTE:** In case you receive warnings that refer to multiple declarations of libraries, please keep one of the mentioned libraries (preferably the highest version).

## Necessary Code Additions/Changes

Within the code, you must change couple of lines to paths and keys/tokens that will be unique to you. There are also couple of lines that SHOULD be general to every computer (e.g. C:/tmp), as well as URLs that assume the tools and services run on default local settings. 

First of all, we need to setup the Twitter API credentials. Those will be provided by Twitter when you create a project with your developer account. It is important to have elevated access, since the standard API does not provide streaming data, which is what we will be using. The credentials need to be added in the following lines of code:

- In [producer.jsp](/WebApp/WebContent/producer.jsp) you need to add:
  - On line 65, your Consumer Key (this is provided when you create your developer account).
  - On line 66, your Consumer Secret Key (this is provided when you create your developer account).
  - On line 67, your Token (this is provided when you create a project).
  - On line 68, your Secret Token (this is provided when you create a project).

We also need to change on various paths for the avro schema. You will need to add those paths in regardless if you decide to move the schema. The locations are the following:

- In [producer.jsp](/WebApp/WebContent/producer.jsp) you need to add:
  - On line 46, the path that the schema is located.
- In [formatter.jsp](/WebApp/WebContent/formatter.jsp) you need to add:
  - On line 28, the path that the schema is located.
- In [twitter.conf](/FlumeConf/twitter.conf) you need to add:
  - On line 23, the path that the schema is located. (DO NOT CHANGE THE "file:///")

>**IMPORTANT:** You will need to also move the twitter.conf file inside /apache-flume-1.9.0-bin/conf folder in order for Flume to work.

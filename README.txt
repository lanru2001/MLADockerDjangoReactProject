#Build a fully production ready machine learning app with React, Django, and PostgreSQL on Docker.

This project is a simple machine learning application with Django REST framework, which predicts the species of a sample flower based on measurements of its features i.e the sepal and petal dimensions – length and width.

The Postgres service called 'db',  is the simplest as it just needs the environment variables to create our database and serve it to the django service. 
The react service sends the API_SERVER variable to the production build version of our react application, maps the build folder to the corresponding folder on the nginx service and serves the react application with the create-react-app suggested 'serve' server on port 3000. The react service is dependent on the django service. 

Prerequisites:
- Python 3.7 + 
- Javascript 
- HTML
- CSS 
- Basic Linux commands
- Docker

#Tech stack 
Backend 
– Django 
- Django REST framework
- PostgresSQL

Frontend 
– React 

source: https://datagraphi.com/blog/post/2020/8/30/docker-guide-build-a-fully-production-ready-machine-learning-app-with-react-django-and-postgresql-on-docker

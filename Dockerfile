FROM alpine:latest

ENV DEBUG 1
ENV SECRET_KEY django-insecure-vq5=7^5ks@_yi1tt74852(k@zfnj@24g3g^#^446#=&i(j%g@0
ENV DJANGO_ALLOWED_HOSTS localhost 127.0.0.1

ENV SQL_ENGINE django.db.backends.postgresql
ENV SQL_DATABASE django_dev
ENV SQL_USER postgres
ENV SQL_PASSWORD django
ENV SQL_HOST localhost
ENV SQL_PORT 5432

ENV POSTGRES_USER django
ENV POSTGRES_PASSWORD django
ENV POSTGRES_DB django_dev

RUN apk update
RUN apk add postgresql openrc python3 nginx curl
RUN python3 -m ensurepip
RUN mkdir /run/postgresql
RUN chown postgres:postgres /run/postgresql
RUN su - postgres -c "mkdir /var/lib/postgresql/data"
RUN su - postgres -c "chmod 0700 /var/lib/postgresql/data"
RUN su - postgres -c "initdb -D /var/lib/postgresql/data"

COPY /custom.start /etc/local.d/custom.start
RUN chmod +x /etc/local.d/custom.start

RUN rm /etc/nginx/http.d/default.conf
COPY nginx.conf /etc/nginx/http.d/


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV HOME=/app
ENV APP_HOME=/app/web
RUN mkdir $HOME
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/static
WORKDIR $APP_HOME
RUN pip3 install --upgrade pip
COPY ./Docker/requirements.txt .
RUN pip3 install -r requirements.txt
COPY ./Docker .

ENTRYPOINT /etc/local.d/custom.start

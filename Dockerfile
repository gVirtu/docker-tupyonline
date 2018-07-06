FROM python:3.6.5-alpine3.6

LABEL maintainer="Giancarlo De Roberto <giandroberto@gmail.com>"
ENV TUPYONLINE_VERSION=1.0.3

WORKDIR /opt/app

COPY www/v5-unity .
RUN rm tupy
COPY www/v5-unity/interpreter/tupy tupy
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8003

CMD ["python3", "-O", "bottle_server.py"]

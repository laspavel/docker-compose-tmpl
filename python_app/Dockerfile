FROM python:3.6.8

WORKDIR /app

COPY requirements.txt ./
RUN pip install --target /app --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED 1
ENV PYTHONWARNINGS "ignore:Unverified HTTPS request"

COPY /app /app 
CMD [ "python", "-u", "/app/start.py" ]


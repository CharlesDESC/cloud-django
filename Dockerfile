FROM python:3.14

RUN mkdir /app

WORKDIR /app

#upgrade pip
RUN pip install --upgrade pip

COPY requirements.txt   /app/

RUN pip install -r requirements.txt

COPY . .

EXPOSE 443

CMD ["sh", "-c", "gunicorn job_board.wsgi:application --bind 0.0.0.0:443 --workers 2"]

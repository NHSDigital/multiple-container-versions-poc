# alpine builds from source instead of using wheels, which is much slower
FROM python:3.9-buster
COPY requirements.txt poetry.toml /app/
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

COPY poetry.lock pyproject.toml /app/
RUN poetry install
COPY my_service /app/my_service
CMD ["poetry", "run", "python", "my_service/main.py"]

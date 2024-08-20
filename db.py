from dotenv import load_dotenv
import os

load_dotenv()

def load_db():
    DB_NAME         =   os.getenv("POSTGRES_DB_NAME")
    DB_USERNAME     =   os.getenv("POSTGRES_USER")
    DB_PASSWORD     =   os.getenv("POSTGRES_PASSWORD")
    DB_HOST         =   os.getenv("DB_DOCKER_HOST")
    DB_PORT         =   os.getenv("POSTGRES_PORT")
    DB_DRIVER         =   os.getenv("POSTGRES_DRIVER")

    return f"{DB_DRIVER}://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"


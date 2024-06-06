from flask import Flask
from flask_toastr import Toastr

from src.app.middlewares import register as register_middleware
from src.app.routes import register as register_routes
from src.app.infrastructure.config.parsers import load_config
from src.app.infrastructure.database.session import create_sqlite_session_maker
from src.app.infrastructure.log.main import configure_logging


def main() -> Flask:
    config = load_config()
    configure_logging(config.app_config)
    session_maker = create_sqlite_session_maker(config.db_config.full_url)

    app = Flask(__name__)

    app.secret_key = 'Secret key'
    register_middleware(app, session_maker)
    register_routes(app)
    toastr = Toastr()
    toastr.init_app(app)

    return app


def run():
    app = main()
    app.run("localhost", 5000)


if __name__ == "__main__":
    run()

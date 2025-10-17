
import json
import logging
import os
import sys

from .config import SystogonyConfig
from .cli import MainCli


from .exceptions import (
    BlueprintLoaderError, MissingServiceError, NoSuchEnvironmentError
)

log = logging.getLogger("systogony")


def _main():

    config = SystogonyConfig()
    config.configure_loggers()

    log.info("Starting Systogony")
    log.debug(f"  PID: {os.getpid()}")
    log.debug(f"  Args: {sys.argv[1:]}")

    config.flush_pre_log()

    MainCli(config).handle_args(sys.argv[1:])


def main():

    try:
        _main()
    except (
        BlueprintLoaderError,
        KeyboardInterrupt,
        MissingServiceError,
        NoSuchEnvironmentError
    ) as e:
        log.error(f"Exiting due to {e.__class__}: {str(e)}")

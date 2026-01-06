
import json
import logging
import os
import sys

from declib import DeclibMain, DeclibLogger

from .config import SystogonyConfig
from .cli import MainCli


from .exceptions import (
    BlueprintLoaderError, MissingServiceError, NoSuchEnvironmentError
)

log = logging.getLogger("systogony")


def main():

    try:
        DeclibMain("systogony", Config=SystogonyConfig, Cli=MainCli)
    except (
        BlueprintLoaderError,
        KeyboardInterrupt,
        MissingServiceError,
        NoSuchEnvironmentError
    ) as e:
        log.error(f"Exiting due to {e.__class__}: {str(e)}")

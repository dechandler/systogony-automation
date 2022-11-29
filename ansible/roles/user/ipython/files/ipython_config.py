
c = get_config()

c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = [
    "import os, sys, logging, json",
    "%autoreload 2",
    "jsonify = lambda x: json.dumps(x, indent=4, sort_keys=True)"
]

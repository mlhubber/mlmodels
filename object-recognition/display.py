print("Loading the required Python modules for the ResNet152 model.")
from objreg_utils import (
    _save_tf_modeo_graph,
    _MODEL_FILE,
)
import shutil
import subprocess
import signal
import time

print("\nLoading the pre-trained ResNet v1 152 model.")
logdir = _save_tf_modeo_graph(_MODEL_FILE)


# Run TensorBoard for visualization
print("\nStarting TensorBoard for visualizing the model graph.")
tb_proc = subprocess.Popen(
    "exec tensorboard --logdir={}".format(logdir),
    shell=True,
    stderr=subprocess.PIPE)

# Wait 1 secs for tensorboard fully started
time.sleep(1)

br_proc = subprocess.Popen(
    "xdg-open http://localhost:6006",
    shell=True,
    stderr=subprocess.PIPE)

# Wait for browser to be closed
output, errors = br_proc.communicate()


# Send Ctrl-C to tensorboard
tb_proc.send_signal(signal.SIGINT)


# Remove log files

shutil.rmtree(logdir)

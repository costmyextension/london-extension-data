"""Mirror data/ and the dataset card to the Hugging Face dataset costmyextension/london-extension-data.

Needs HF_TOKEN (a write token of a member of the costmyextension organisation). Creates the
dataset repo the first time; afterwards uploads only what changed.
"""

import os
from pathlib import Path

from huggingface_hub import HfApi

REPO = "costmyextension/london-extension-data"
root = Path(__file__).resolve().parent.parent

api = HfApi(token=os.environ["HF_TOKEN"])
api.create_repo(REPO, repo_type="dataset", exist_ok=True)
api.upload_folder(
    repo_id=REPO,
    repo_type="dataset",
    folder_path=root / "data",
    path_in_repo="data",
    commit_message="Data from costmyextension.co.uk",
)
api.upload_file(
    repo_id=REPO,
    repo_type="dataset",
    path_or_fileobj=root / "hf" / "README.md",
    path_in_repo="README.md",
    commit_message="Dataset card",
)
print(f"Mirrored to https://huggingface.co/datasets/{REPO}")

# standard libraries
import logging

# third party libraries
from setuptools import find_packages, setup

logger = logging.getLogger(__name__)

with open("README.md") as fp:
    readme_text = fp.read()

setup(
    name="virtual-lab",
    version="0.1.0.dev0",
    url="https://github.com/enyquist/virtual-lab",
    description="A virtual lab to refine LLM Agents for Network Analysis",
    long_description=readme_text,
    author="Erik Wyatt-Nyquist",
    author_email="enyquis1@jh.edu",
    python_requires="~=3.12",
    install_requires=["litellm~=1.54", "vllm~=0.6"],
    packages=find_packages(exclude=("tests", "tests.*", "scripts")),
    entry_points={"console_scripts": ["virtuallab=virtuallab.cli:cli"]},
)

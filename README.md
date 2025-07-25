# 🚀 Install Extend Helper CLI

A GitHub Action to install the [AccelByte Extend Helper CLI](https://github.com/AccelByte/extend-helper-cli).

Downloads and installs the specified version of the CLI executable into your workflow environment.

## 📦 Usage

```yaml
jobs:
  install-cli:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install Extend Helper CLI
        uses: elmernocon/accelbyte-extend-github-action@v1
        with:
          version: v1.0.0      # Optional: leave empty to get latest
          os: linux            # Optional: linux, darwin, or windows
          architecture: amd64  # Optional: amd64, arm64, etc.

      - name: Use Extend Helper CLI
        run: |
          extend-helper-cli --help
```

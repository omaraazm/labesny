import uvicorn
from labesny_api.main import app


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)


# Or you can just run it directly from the command line (this is the most common approach):
# bash
# 'uvicorn labesny_api.main:app --reload'

# Run the API from the root directory (backend/) using:
# python run.py
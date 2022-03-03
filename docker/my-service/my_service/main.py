import os

import fastapi
import uvicorn

VERSION = os.environ["VERSION"]


app = fastapi.FastAPI()

@app.get("/_status")
def _status():
    return {"version": VERSION}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)

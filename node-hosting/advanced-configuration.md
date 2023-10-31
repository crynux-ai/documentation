# Advanced Configuration

After mounting the config folder to a local folder. The config file will be created inside the config folder. Here is an explanation of all the config items.

```yaml
log:
  # The directory to save the log files
  dir: "logs"
  
  # Log level could be "DEBUG", "INFO", "WARNING", "ERROR"
  level: "INFO"

ethereum:
  # The private key of the wallet
  # Must be filled if headless mode is enabled
  # If headless mode is not enabled,
  # the private key can also be filled using the WebUI.
  privkey: ""
  
  # The JSON RPC endpoint of the Blockchain node
  # Here we use the private chain for the Hydrogen Network
  provider: "https://block-node.crynux.ai/rpc"
  
  # The Blockchain params
  # Leave it as is for the private chain used in the Hydrogen Network
  chain_id: 42
  gas: 42949670
  gas_price: 1

  # The deployed addresses of the smart contracts
  contract:
    token: "0xB627D84BFB8cC311A318fEf679ee498F822A0C7C"
    node: "0x73F8eAD4d29e227958aB5F3A3e38092271500865"
    task: "0x3f4e524d5Ff53D0e98eE5A37f81f4F21551502B2"

# The directory to store the temp files related to the running task
task_dir: tasks

# The database used to store the local state data
# The data will not be large. A sqlite file is more than enough
# There is no need to mount this file to the host machine to persist it
db: sqlite+aiosqlite:///db/server.db

# The URL of the Relay
relay_url: "https://relay.h.crynux.ai"

# The directory that stores the distribution files of the WebUI
web_dist: dist

# Whether to enable the headless mode
headless: false

task_config:
  # The directory to store the temp images for a task.
  output_dir: "/app/data/images"
  
  # The directory to cache the huggingface model files
  hf_cache_dir: "/app/data/huggingface"
  
  # The directory to cache the external model files
  # Such as the LoRA models from Civitai
  external_cache_dir: "/app/data/external"
  
  # The directory to store the temp logs generated
  # by the task execution engine
  inference_logs_dir: "/app/inference-logs"
  
  script_dir: "/app/stable-diffusion-task"
  result_url: ""

  # Models that will be preloaded before any task execution
  # Other models specified by the task
  # will be downloaded during the task execution
  preloaded_models:
    base:
      - id: "runwayml/stable-diffusion-v1-5"
      - id: "emilianJR/chilloutmix_NiPrunedFp32Fix"
      - id: "stabilityai/stable-diffusion-xl-base-1.0"
      - id: "stabilityai/stable-diffusion-xl-refiner-1.0"
    controlnet:
      - id: "lllyasviel/sd-controlnet-canny"
      - id: "lllyasviel/control_v11p_sd15_openpose"
      - id: "diffusers/controlnet-canny-sdxl-1.0"
    vae: []
    
  # The proxy server used when downloading models.
  proxy:
    host: "http://127.0.0.1"
    port: 33210

# If the node dies right after submitting the commitments,
# and before disclosing the result on-chain. 
# And if the data is corrupted inside the container,
# which prevents the node from starting again.
# The result from the previous task execution must be fetched from
# the logs of the dead container and filled here.
# So the node could continue with the unfinished task correctly.
last_result: ""
```

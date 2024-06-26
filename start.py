import os
from elvia_vault import VaultClient

vault = VaultClient()
bootstrap_server = vault.get_value("edna/kv/cloudevents/info/bootstrap-server")
key = vault.get_value("edna/kv/kafka_lag_exporter/creds/key")
secret = vault.get_value("edna/kv/kafka_lag_exporter/creds/secret")

cmd = f'/opt/bin/kafka_exporter --kafka.server="{bootstrap_server}" --sasl.username="{key}" --sasl.password="{secret}" --sasl.enabled --tls.enabled --sasl.mechanism=plain --web.listen-address=":2112"'

os.system('ls -l /bin')
os.system('whoami')
os.system(cmd)

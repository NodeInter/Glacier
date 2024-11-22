#!/bin/bash

# Nama folder utama
main_folder="Glacier"

# Buat folder utama jika belum ada
mkdir -p $main_folder

# Pindah ke folder utama
cd $main_folder

# Download binary jika belum ada
binary_file="verifier_linux_amd64"
if [ ! -f "$binary_file" ]; then
  echo "Mengunduh binary $binary_file..."
  wget https://github.com/Glacier-Labs/node-bootstrap/releases/download/v0.0.1-beta/verifier_linux_amd64 -O $binary_file
  # Berikan izin eksekusi pada binary
  chmod +x $binary_file
else
  echo "Binary $binary_file sudah ada."
fi

# Prompt untuk memasukkan daftar private key
echo "Masukkan daftar Private Key, pisahkan dengan spasi:"
read -a private_keys

# Loop untuk setiap private key
for i in "${!private_keys[@]}"; do
  node_folder="node$i"
  config_file="$node_folder/config.yaml"

  # Buat folder untuk setiap node
  mkdir -p $node_folder

  # Copy binary ke folder node
  cp $binary_file $node_folder/

  # Generate config.yaml untuk node
  cat <<EOL > $config_file
Http:
  Listen: "127.0.0.1:$((10801 + i))"
Network: "testnet"
RemoteBootstrap: "https://glacier-labs.github.io/node-bootstrap/"
Keystore:
  PrivateKey: "${private_keys[$i]}"
TEE:
  IpfsURL: "https://greenfield.onebitdev.com/ipfs/"
EOL

  echo "Konfigurasi dibuat di: $config_file"
done

# Kembali ke direktori awal
cd ..

# Informasi selesai
echo "Semua konfigurasi dan binary disiapkan di folder $main_folder."

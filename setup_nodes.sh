#!/bin/bash

# Fungsi untuk memeriksa dan menginstal Node.js
install_nodejs() {
  if ! command -v node &> /dev/null || [[ $(node -v | grep -oP '\d+' | head -1) -lt 20 ]]; then
    echo "Node.js tidak ditemukan atau versi kurang dari 20. Menginstal Node.js..."
    # Unduh Node.js versi 20+
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js berhasil diinstal. Versi saat ini:"
    node -v
  else
    echo "Node.js sudah terinstal. Versi saat ini:"
    node -v
  fi
}

# Periksa apakah Node.js tersedia
install_nodejs

# Periksa apakah PM2 tersedia
if ! command -v pm2 &> /dev/null; then
  echo "PM2 tidak ditemukan. Menginstal PM2..."
  npm install -g pm2
else
  echo "PM2 sudah terinstal."
fi

# Pastikan skrip dijalankan di folder Glacier
current_folder=$(basename "$PWD")
if [[ "$current_folder" != "Glacier" ]]; then
  echo "Harap jalankan skrip ini di dalam folder Glacier."
  exit 1
fi

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

# Informasi selesai
echo "Semua konfigurasi dan binary disiapkan di folder $(pwd)."

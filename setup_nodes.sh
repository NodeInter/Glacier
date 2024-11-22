#!/bin/bash

# Nama folder utama
main_folder="$(pwd)" # Mendapatkan path absolut dari folder saat ini

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

# Fungsi untuk memeriksa dan menginstal PM2
install_pm2() {
  if ! command -v pm2 &> /dev/null; then
    echo "PM2 tidak ditemukan. Menginstal PM2..."
    npm install -g pm2
    if [ $? -ne 0 ]; then
      echo "Gagal menginstal PM2. Periksa instalasi Node.js dan npm."
      exit 1
    fi
  else
    echo "PM2 sudah terinstal."
    pm2 -v
  fi
}

# Periksa Node.js dan PM2
install_nodejs
install_pm2

# Path binary verifier
binary_path="$main_folder/verifier_linux_amd64"

# Unduh binary jika belum ada
if [ ! -f "$binary_path" ]; then
  echo "Mengunduh binary verifier_linux_amd64..."
  wget https://github.com/Glacier-Labs/node-bootstrap/releases/download/v0.0.1-beta/verifier_linux_amd64 -O "$binary_path"
fi

# Berikan izin eksekusi pada binary
chmod +x "$binary_path"
echo "Binary verifier_linux_amd64 sudah siap di $binary_path."

# Prompt untuk memasukkan daftar private key
echo "Masukkan daftar Private Key, pisahkan dengan spasi:"
read -a private_keys

# Loop untuk membuat folder node dan file konfigurasi
for i in "${!private_keys[@]}"; do
  node_folder="${main_folder%/}/node$i"
  config_file="${node_folder%/}/config.yaml"

  # Buat folder untuk node jika belum ada
  mkdir -p "$node_folder"

  # Generate config.yaml
  cat <<EOL > "$config_file"
Http:
  Listen: "127.0.0.1:$((10801 + i))"
Network: "testnet"
RemoteBootstrap: "https://glacier-labs.github.io/node-bootstrap/"
Keystore:
  PrivateKey: "${private_keys[$i]}"
TEE:
  IpfsURL: "https://greenfield.onebitdev.com/ipfs/"
EOL

  echo "Config file dibuat di $config_file"
  sleep 0.1
done

echo "Semua node telah dikonfigurasi di $main_folder."

#!/bin/bash

# Nama image Docker
docker_image="docker.io/glaciernetwork/glacier-verifier:v0.0.1"

# Fungsi untuk menginstal Docker
install_docker() {
  echo "Memeriksa apakah Docker terinstal..."
  if ! command -v docker &> /dev/null; then
    echo "Docker tidak ditemukan. Memulai instalasi..."
    # Tambahkan repositori Docker
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    echo "Docker berhasil diinstal."
  else
    echo "Docker sudah terinstal."
  fi

  # Tambahkan pengguna ke grup Docker
  sudo usermod -aG docker $USER
  newgrp docker

  # Verifikasi instalasi Docker
  docker --version
}

# Fungsi untuk menginstal Docker Compose (opsional)
install_docker_compose() {
  echo "Memeriksa apakah Docker Compose terinstal..."
  if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose tidak ditemukan. Memulai instalasi..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose berhasil diinstal."
  else
    echo "Docker Compose sudah terinstal."
  fi

  # Verifikasi instalasi Docker Compose
  docker-compose --version
}

# Pastikan Docker dan Docker Compose terinstal
install_docker
install_docker_compose

# Prompt untuk memasukkan daftar private key
echo "Masukkan daftar Private Key, pisahkan dengan spasi:"
read -a private_keys

# Loop untuk membuat dan menjalankan container untuk setiap private key
for i in "${!private_keys[@]}"; do
  private_key="${private_keys[$i]}"
  container_name="glacier-node$i"

  # Jalankan Docker container
  echo "Menjalankan container untuk $container_name dengan PRIVATE_KEY: $private_key"
  docker run -d \
    -e PRIVATE_KEY="$private_key" \
    --name "$container_name" \
    "$docker_image"

  # Verifikasi jika container berhasil dijalankan
  if [ $? -eq 0 ]; then
    echo "Container $container_name berhasil dijalankan."
  else
    echo "Gagal menjalankan container $container_name. Periksa konfigurasi Docker Anda."
  fi

  # Tambahkan delay untuk memastikan Docker tidak kelebihan beban
  sleep 0.1
done

# Tampilkan semua container yang berjalan
echo "Semua container telah dijalankan. Berikut adalah daftar container yang aktif:"
docker ps

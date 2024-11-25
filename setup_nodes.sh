#!/bin/bash

# Fungsi untuk menginstal Docker
install_docker() {
  echo "Memeriksa apakah Docker terinstal..."
  if ! command -v docker &> /dev/null; then
    echo "Docker tidak ditemukan. Memulai instalasi..."
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

# Jalankan fungsi instalasi
install_docker
install_docker_compose

echo "Docker dan Docker Compose berhasil diinstal. Sistem siap untuk menjalankan node."

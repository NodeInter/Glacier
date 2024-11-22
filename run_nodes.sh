#!/bin/bash

# Nama image Docker yang akan digunakan
docker_image="docker.io/glaciernetwork/glacier-verifier:v0.0.1"

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

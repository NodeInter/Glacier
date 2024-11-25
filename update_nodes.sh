#!/bin/bash

# Nama image Docker yang akan digunakan
docker_image="docker.io/glaciernetwork/glacier-verifier:v0.0.2"

# Tarik versi terbaru Docker image
echo "Menarik versi terbaru image Docker: $docker_image"
docker pull "$docker_image"

# Ambil daftar container dengan pola nama yang diinginkan
echo "Memeriksa container yang berjalan..."
containers=$(docker ps -a --filter "name=^glacier-node" --format "{{.Names}}")

# Loop untuk memperbarui setiap container
for container_name in $containers; do
  echo "Memperbarui container $container_name dengan versi terbaru dari image."

  # Ambil konfigurasi lingkungan dari container lama
  env_vars=$(docker inspect "$container_name" | jq -r '.[0].Config.Env | map("--env " + .) | join(" ")')

  # Hentikan dan hapus container lama
  docker stop "$container_name"
  docker rm "$container_name"

  # Jalankan container baru dengan konfigurasi lama
  docker run -d \
    $env_vars \
    --name "$container_name" \
    "$docker_image"

  # Verifikasi jika container berhasil dijalankan
  if [ $? -eq 0 ]; then
    echo "Container $container_name berhasil diperbarui ke versi terbaru."
  else
    echo "Gagal memperbarui container $container_name. Periksa konfigurasi Docker Anda."
  fi
done

# Tampilkan semua container yang berjalan
echo "Semua container telah diperbarui. Berikut adalah daftar container yang aktif:"
docker ps

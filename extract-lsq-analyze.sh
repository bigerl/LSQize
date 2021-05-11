#!/bin/bash

image_tag="lsq_analyze_swdf_log"
docker build -t "${image_tag}" .
container_id=$(docker create "${image_tag}")
docker cp "${container_id}":/LSQ/SWDF-Queries-LSQ-analize.ttl ./SWDF-Queries-LSQ-analize.ttl
docker container rm "${container_id}"
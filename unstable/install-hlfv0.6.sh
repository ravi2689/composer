(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �oY �[o�0�yx᥀C�v��D!�h@P�������\Z6���N$$��Tm��D.����sll��"R�|7�C�عN�݁�n����Uf�QaE�iu��N���Ђ �?�"q��JD���u���SDB�{���!"	�P(] �"wE}$�� �5�H�]����5"�sE�U�(���F�]��nC�%=���D��D �A�
v���R�L|�E^tM�鍬j�r`�F���Y�f"{�Q*�m뚞-e���$��� D�-d��Z�&0����������&�f�E���,�F8TeM�/te(��@?�� \Ni"�se<�{����f����Ib�i�۹�[~�D�Ƴ�1���7�o��Ϗ�=�����ؐi�,�^�⬆g��[���Fh�`����b?�ITe2��P�ŝ��*���}�j�8X����6��n�ta�u�B� t>�e��m�!�t@�;��2��O:S��9M���/A=p�ݚ��g���5���������bKx�L�F�8Pf��>� �8<P�|�CVD��9���ª�SP��y١�y������<U�(��'���p�	���q�g.:�h�4-�I�in|��l2ndӬ`�	��쳸���?d�M�&�Ew�I�'`��9v �(�q�ūR�X����w_L�8M�aA���ߢ�('yμ=_��I̛
n�.N�5&��n���:��_�8>���U���p8���p8���p8���p�&?�h� (  
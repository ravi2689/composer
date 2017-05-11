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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�D1���/�cEu����<�&[�i��e���i�r�����p�?������rz���x�}Ȍ�\�M����k�-Ae"\,!p��x���/ީ.�?J�d%�2p������+���p��	�Z�����?���:N�W&������_��k�?�xv���'=�(`� ����Z�{��\@P���/��'�������g�^����c�?��.��.�y��S6�6J�4JS�C6�,BQ>B:>���`��x�(��M�Ys���Q��O�"^��8�>��x�Y�K)c �p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��:+��K_�������m/�.]?]��1|������_)�(��U\�^'~����������@+�_
�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��A �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!e�^=ܗ� v0?�`����С�C�����������N�����5���r7�6�8Xs�+���n�b.�q�|������[K���
�4���6A(�(:�)( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� ���=!98�ģȓ�Ơ�/F^ .ԏ���4<��XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋYW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G���K���Q�S�U�G��?��T��e�5�g�;���@=2̛흺_���@�8��В��X>̐#q���^B�Џ��
|Hʑ�z E�����de���2s��I���:?�2��4]�!�l��b��p��#v�D���[�NuM1GkH���5q"5q1u{W���~�y캼W�y.�V�v�
�~ ����2t����[���˶:U �U��ք9P�m�0<Z GZoi�rf�m qyQ��+ ���t��k��k��Aȁ3_�A7��}���|Ƿ4�צ����4���I#�9�u �-�5�!��̶��	�4���qG�"j>ob��bM�CAn�{�I���sn
��L�k�t���mfՇJ&�����)~I�����=�O�T�Q
>D�?s�����Gh����T���W���k���sL���O�8U��%�f�Oe���*�������O����%������8E��_�!h��Ew�e
���E� �h��H�����P��_��~�C�D������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*��������?T�_
>J���V��T���_��W���K�b�Ou��|���H�O�������L���7s(<:��P�қ�]���O�������:vK}�������`p�{;h2�} ��U�>2�2<�$�zo*ͭ��3A>���w���]����t�x�͆�f2o�z�D���D!P����]�p�r'�v�ó@�D�s�m�ȸ��IG�^p ?G��qڠy����8�9@z��%�i�V��ڹN�M�}��6Y��.,����μ����´gO&M��@�$0A����^��Y��h1	�x�� ��i��=SZ������SMG��v"FR>�9K����Ё��yW 'Y1�������)~I�f�V���F�O������+�����\{���ߵߝ�r�G���Rp��_��q1�cJT�_
*������?����?�zl hQ�T�e����t���GC�'��]����p����-x�a	�DX�qX$@H�Ei�$)�����P��/��Ch���2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x������O����D��_� ����������].����˔����I�Z����Px��e�p��i�@+������K�A/�?�bHu����?�>?�IW�?e�S�?K#t�������6�26�R��Q��,��x4B��x���o���FQi(C������1�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���ϻ����������J��`�{<���c�����||��P}i�P�2Q��_��P�|�M x�������1�������]���X��a������G��п�����q����r1��Zo�H_�����A�9t�z��K��<�Ѓ��v��3q�p�i��N�c1/��]h����Cb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q>#=<$l��v:$�\h���@8ǻ5u���(J�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey��·A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`��_:��'*����?�W��߄�Y�?��܀�e��U����O�����m�?���?�m�a��o��N2;M�p�g�?�?�qo(�g���@y�@wA�zd������5`�uM|����䃀$�H���PwSR������ؚ���ms�ѷl���D��!�5S9v-Mhҩl�$��ԺN�t-�\9N�j�x-�4!���A��}�R{���Ț���	�H�6k��y�^wӾ�R󬑬�R��S2���k�g�`�r����߃�N�Ѱ	#$�{Da�6������H��R:��������R�[�������OI���_m��sP��߳�������|T������_���Q��+���?�a��?�����uw1�cBW񟥠����+��s���������?�ￕ�������1%Q�q(�%\���"��� p���G	�X�
p�G(�����*�o�2�������/������|\p�(-S���o�S3��N_`�Мznl[�b�7�H[��ɋ��A4������7�;��%k��0�}����0���C�[WpD�S�޵t����MN1���Je�iͫ�?��s?-��ę������Gȧ�_�~��l�4+����_�_���v���W�Vsm�x�զ��_k�}�����N:u�\�뎡n(�
�F��+{�L��g��v����_��7�ծj�t����M����`��?��ձ~z�`����=�E#$���ϿNe�č����MjWn�����Ż�]%��݊`��k�>�I>������e����y�+�v:`���o��U��NC����0F��%Yݾ��[܎�rmO�~z���bV����͠����p;s�6��}eZ�6�hnuuA�E��!��:7�o�*]���!ק?/�>^�r_�fW�v��kM%��|��^�q�����W�v��}��]t�~O�u�(޼�Z���=����`{�F�S����j/�����-�D��i�Žyx<�}\!?�����7�[o?����<����oe߯�?_�ǖ����5����N]��t>]�7�4�Z��d�qb�'p��p8]O6�u��~��I�^�=,|�	�!�#%pVϗ��}��#���#��Ⱨa��z8U���m.R|Wo�&�U�+�7�H��hȊ��أ�*��o�t�?.6�b�����6���+Ó8[�[;���>[R�o�jc\��t{����Ko��Xnz�z����8N�Rǉ���$�w�Tw=�c'qb���
������X��hA��$�~��?��]�Jh�PW-�E+?�c'�$�d&3�ޖ�s�;�����s^�~�9��n��D��B�>���K��t6gLlr�rKn%$l"��Y*��������芬�t.���Jgc�(	�m];f�:y�P������fSd��c3��E�E�V�i�G�h1�	A�d^����P�!&Ly��+����(� ����]��.A�F �5�� �ڱ2�0�R��Z\�k�7,�l�����P�Ǧ*i���G��a��~G��3���':m!_JgZ�{�%�jb��)�W�w�8gބ�c���_3�ܜVe�МF,#!��R�n���a�m��/�+��Sn��/M�������qz����^�M��h����t��n�t���)v8]�ɁSN���%8%������tvb��;�G�_gW�A���MM�G���:�U��(�!<���=j�S���e������_�:��l&m��Dw=aw������w���3�j���$���Ltn�
�f�<(�G%j�!�ͬ��v������p(Z�ׅ�Ӓ���eSE^ə동RPۢ����p�ܴ([�(MQG%���7��=�%�F�����%�����OG���|=]1�-� �����w�y>p��SK�F��Uh{4��$�#1e�c಄�[�q�ˌ	Z��%1�O{Ӻx��n!�����7��Z�b���l���ZU��ۅ��]��v}�`�Յ;p�X�U5 ���>��ټiѽ�Bpx��'o�dc�c��U������������������'��$x��.�\���>������*q��}��z|�z�)ćxlߏ�� �%�����x�o?P�{�@j�Ob�O���'".p��ޑ�o��Е���S�s�v���?�Կ�z��?����3�ҝ�1�w���i ����� �ő���5�&���k��!���p�+O 5�sS��tS���+-��7o0��y`B�#qYH�ya�66���I��9i�\�,��A�<�����ma�7���a�B�' ��p�@�w#�>�M��^�7�-�qj���^!X��{��1'��\��1UuPh��0,��>hFY�Xq"�,6ó��m�`ɊI�H��lC�p%JSE����aT`�������q�e�lx�#\b�U�0O΄Wɂcv{k��H.��\k7S�<tJ�T}�f�8`�d�R��W3����Ҿ�G�i�R�^E�U��1��3zFC�~�a��V�#�!_��0a&�Ä݄	�|�D�ݏ����ѹM=!�ڛz�S�k~~K�)����FȺW�(%��x���c^2��$ӡ\Z��R����L���Hb����sa�P�q��k�=��\�η��bJ��Q�CV���,��fP���A*ҍ�x��S��^��+XBV��E�>�����ë���j2F3�X�'��lDI��8-+�z�����z��
7��T�D�%%��Ho3\��m4_}e�����ـuAY����BDKt��:���(�M�4��V�(��N<Z���>�u��H1J�3�̈́KIF��N ��ڨ���锅��h�&�FK�:`X�pE2�Q2K�rDxAv���u	��x60�)�/&�N�WC� PO/W�h���$f)�h\/�q����Τc� Vhs��TO{��<�EJ���$V)�p���W�����c0r�&q��y �y�ᩱ7-��F��_"�hPˊb�,�"�GI-^V�
�ԸV��ɖp�{�XBi�)����S���n(�Q���z����?�e<�\U�%e9"� �VY��.�q���!+Ut	e�<;(-����?�����ݖ����h�B�R�_��˱|Z�1l�����^�;NY܎���l�϶�϶s�4~�w��FW��]ȵ�;�d��^غc�
���Wi;�L���ʾ}.�6re>����UeE�v��v��滂l���^�����{چ-��B��9(�*a�<���#AԺ��LN�<�&1��ht���U�@�檺��gĎ�3�#MD��Kࢡ*�-��X��5�"����~�ocW�y�eߦ�ȕ�7!`�{��-s�6)�E^iԬ�#oE���؏c�<��l��y��S\W����2�i�/&>�9bV�H?�Sd�AVu�㙁��� ���H�����1�����!�y��6��m���s^
����_
�;q�,<��d;4�5s�>Q
S�b'�������}�A[)����\t0��֢��b�a_l��`�Ȃ�3G�u��Y���i�7k� �yp�{X0�����},C��1����eگ���F�x%�ǹP4V�3R����$�x��a�9т_J��~���U�x:��&�6�J�Y�k,�T92��Z�̀�b���#d,,e�cr�4f�C��5d���P�h"�PB���������{��Ԙ`�F��Z�GЁ�X,��Z2����U�����<�f������pd��^H2������`zá��C�����h^mp\j�A6!����1�8�8���zI� o�N�[��˦?4uL�s�|�s`�g�(�|p.ý�e;á�;�'zX���?1;Ʒ�������xXN$�I�t��G�V%ZKc��i.�$���XR ��78r8X,��h-*7Il!�"��8kPd�*0	��7kβ���ab���`1��m-E�� )G�2
����C�;��E���3r1^�0��U�O����x}=RU���h4��l%�`LB��K�����p�`�a,�*���(���!�|�-v����+`qO���b����K;� C���Ƥ S��J�F�E5\��c4ϥ0f��Q"lmO-���qCN�)$Z� |��E�ڬb�^?Mz�
-�����c�q��ǩ��b�o#��{j�l!����Br��vn���]���qސ)��{B��[�­��tߜ��4�I�j�h�{�>p�����������[���l�K�8���; �Q�<�G5���E�r����6�����{��=�~���g_��s�����������s?����ך��Ŵr��9�q"��]�#�w���%���_��o=��_���o�������L>��g��>������\���{|)	��A��֝&�o���^��d:Q��� W��Н�{��m���v��8�/������o����A~=G���yy���K���P;j�Cph�����z�������C�t���������@�<5��6�Ao��T�	4�Rf�a���ۢ��m!t�����o=gb謏��<B���u�9j���3p�:�g�|Ju>�:<�8�x�xg�H��5p;������4�u��3gƉ�:sf�iδ gΌc�q܆93g��{�)0�cf΍�Ý"��)m��%��#����vm�;&���$'9�I���W
  
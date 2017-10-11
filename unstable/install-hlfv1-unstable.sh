ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� #�Y �=�r��r�=��)')U*'٧Y�YKk�H�壭��%R�M�d�h����bh\HQ*��'���@~#���|G~ ���W�"Y��f?H䠧{.��=�����&2}
n���|m��&v��k�O��D���Aa�?��$D��!1�D)�b$$�� ��/ǲ�	�ۄ͚�����:ȴ4l��g!��)���8 <�0w�g�Ͱ�f �܀-�3|�j-X'e�^�:R�����CmcӶ\� ���ma[ء^�2dt4-d���a�谔*�'��lf��= �z���@S���n�|���l�B����$���吾��H4�!SV[��/���:�X	)&�i��a�RJ%U#���\�v�&0�D�]ܹ�f>�Ϧ��0�b�A;2qM���6�ak�5X55eQ�Ud)�ֶ�	��FҬ2�~a�T�u�E�M�;�z��&�4p�8�
4�<�̢uk!_���C�9$�"����9�?�CZ��Ӧ�Ͷ�x�����:�=؉
aa��S����P\���5(ZP�e��IZ�Ь����"\e��2���n��+Џ	���K�Td �3���9����ͯ�>:Ȳ+Ń�i�ԅ�=]$�C��C���C�,;w[P�Tl�����(�9�]l6�]QQ:�g=Х�L�[2i��=\�s[���
�SQ�G�?�����N^4���Q�aA
��|?�o������o#�F���W�ո/6����/�t��!)%R.F�`d����}�jF�
�ga�T��oEe�Tͤ+&�|�K{��J1�z'|��`���]�|
��g�����a��Sݧ��Y�_�����/f�*MXG���Is��Ġ��������s��)l9v"�~�vK��f��F&(�2�Б���#P�&٫u����P����ڎIwf߶�u�M�f�bE&"�5���i������ކw� �"Z��T�&60���X���>�mJy��lN�9%�n�tMA��x�Dk��΢�aّ��]??�x�ʪ���Ҁ�S;�ºCԢ��sd7�h��z�Bw���8TMW}�TZ���uGo�����r��Jq����LD�&�R��������V�_i�#�/���Gd�'��'�:���D����d|>X���u=����\������?(���^�W���P/����m��t@C&j�"���ahF}�R�↕,�7��k�;w�o�L�@���[�V�7y$�]����kJ� KR����	ۛ|x ��D`޹�ǁ��Q�ja�dǹ�r/�N�߆��� ��(�>��p �����d��"Bb8b.
��Q�=�&�my��z����5�%�&��v�����<l̦�mpATf�U�22��[�GU>�?%A��{l@���C�@��B�K�v�H��#"�
�f�J��*&{v�����B��������t�ؠ�Д�̳?�s?Z��L8���6�QG �9O��[�G�g ͠��x��8�&�pߨR����({��S�� TM��_��8ݡy}�k�C���#*�����_*̰�T������"ᨰ������ϗ3�4��c���R0:�����w5��I��9�띹g쌆xz���G�1�<G�݌	����&�@V��`��%���OXN��^�t^J�G�ݟ�ڄ�j����������c���I�Y�]/7-ǋ���q�X��_^�Gn���N  ��a!�q�-�E�aC��F���
�^T�tͧI(ҭ��瓏Hc�N�f{Ke�X>/gs��Jy~�'�f�]�M��R��]���+��>P��D�/��N��>�|΢�H��ށ�3��<7���$̹����'�8�Ӫ"�?~|��R ҺtL�ttz@'�a%BFį��%�;.��bAP�I)�#6c�W���F����wkpg�/(D���j`��}�0s�M�!7���?$
��_4]��*����{��^�3���A&Dׁ��6QM�;N�Y���so���S���y,�/�s<�GX����?���K
�<���z�W����/;������"k���z����pl�=�i� �&6_�����B�Ղ�j�9�����Ȧ�X�	�䘈����ݟf�}����?����-5���c�o���'X�ճl�4Ȉ��1��EF�������tp+�jS%�r��4�Vȴ���c�4u�@�Iو{f��Ϭ�?��3ު#�ۄ{��bO!�n�~cĢ��"0�Z� ���z�LW��3�;%N�`�4�Ac�r����}����4}�
Q�o��?>��%򑮚+\��/DĆuw-�,|tFT
}{�k~nDk�ǁzO�=�0���_\���;a+��ܥ�w}�N<��4��D���[��OP�2�K�)��Ck�_	����8�,����6���!����@�p�����]����}^
-���L���W���Gy���e7D�;�Ч�C
n� 6� ��'`�9 �ìc@�V�4���rJ{�@ù�hC�&8�B F]^��p��!T����?��a�x�Q=a����4��Rf�(�v/ـQ���m`�v��x� ��!^���u$��L�4��@bF����@33gLp�N�1+1�D��\�]�J$��z�0��/� �<ʼ\)cyf�� �\�#b�E�̺�4�1Ѐ1���$R��̻��^�
���#~�pk�?X�>������hPZ����<��E�]����2t�������pXZ������;�>|��������������??��BUA��`l����(�`�Z���X,R�ƂR0
�$")"Ū���@)���jt;�n����5����i��ƿr'�ۺF��lp�pE��Ɠo�s\6m�im���?q6*�������W�D���o���y��,ם��/���6���$]v?��91��մ6��� ���`��h���W0�������w����<�;������j���n�6<������/E�u�ו����O J��Jʆ;�ARz��kd��A7�O��Lm:Y��\�V��lY��{E%��F�5A�n����v����Ĥ`��l�PPB��@q;
cU1
aJR8JXhCj׼�ȲZ�V�v�G!��d� �*���lB.�X�{#��&2���$�r7��٢�w���˞�gz�mTé�^�&��}|���R��\�����J*��%��s��+���	�r��oT3z�z����e�B��ϔr�<�����J;�A��4�}�)�o]\Neb����s��Ѩ��[g��E5(\�%e���ʩ`���8h����5�|��t��`�����	-�`e �qr��
V7Q8M
�T��q�*UΑ���K�s��`ڂ'g�n��S'�x���e.�ި�N6u�;=	_�����U���C�vO
'E��e2F��Q&m+�K����T��32��\&���)夘\Oe	�s7�'Y9�q��/�1Ӽ,�s���Ϳ�N�O.�v$I��X~�3�'�Q�X���}y?Ւ��sѳ�Y���Η�Y+�#gR���w�/���AN��\�֪�n*���Փr���^1�k�)�B�s	��J�v�\b_��[�t��l<��0���~�c�E4 M!�������r''�a��&d�.�R�D�����B佑H�?V˧HچW��I,�0�^F��0*'��q��P�l�ޏ�V�MO�i�j�T���E��{��qn�
Z/!Ţ5_)ʻ�&�|r���~��~:�F�@3���ƌ����O�D77��D1"D���Gj��c{޲�R�D�ߵ�GS�|aE�d��~���:�o%0�'���8���)+}�岙=b��E6:����P�B]�݃��>�1�Y�<���c�$�E�̉�w�t)W���t��J�r��$�B%_l�*ͫ4LD_^K���_VQ�)'7+�B1��u��3Z=�81*;�� 
BE$+N� �WP�s�K<冖�f�>���r��a����?������f��������2�p��_��\	���J� �7��f7�=��?rax��J�P�S0�5S�d��or�'u'`��M��Z��>L��s�R���[�8]�50��q[��?h^ن�2䣮x`i�K!��6��,L����q>ݲ�=j����mLKjZ�߃����%������W�@�{&����s���Y�A��Y���\�~���<J���io}�YnMC��%x��p@��nҡY�x�IT��EL��ꂆv��-Ђ���'^�0��.�<d���CZ�a�Sz�G��y�#8# $qj���b�͛R�Km��Y,!�k:���t�e!Ht�ё��X��Gjk������e������򠿷�b��("<h�c�o]|T�e�G�;����h�+��q�v�e:f�E����AtI�4���՘��D�
z�1=z��vL&W~ r�/�@�^`�B��R"E����A�r�ѥ��aݦ ��i�eHI�lSC��"6`T֣�-�6���]���UOߞMi �E�����b�L���)��
Xа�|�t��ctd̰����![2����B�[���G�G���TD��!�I�uyҿxo��b����&	�L��B௯�����~�͕�~�_H��M[��2��;��5�Xch����%�9��
y<_Ym*h����&�c�����0&eZ˝�xR2'�������`�b�Ǳ	�`r�!+���t!�gY�`���lR�sʯoqh��/ĵ��ѽ��D����&�vi���a��Q��e��d��:࿩%:�M�Wk"7P��Tޭ%Ѕ'�����;�1~��^�V���h�%����+�j7�W�2_*��%�}�#�us���}.M��(�K����`���*��D��k#�v�.�t`hR�c;t@Ȣ��E����~�F���G�[��L֔;��MT���ޱu��&�ɊN��!C���jCz��
�u��H��H�S�X�;m;n�>W����`�2du;b�|�}�1K���'��_|4u�X,��c��Ơ<!�Զ�(��Ή5���4�
��y���NMВM����֑A,��g?b������(�?{��8���{���nz���B5Ӎ�R�Gb'�LIm�N��8O���ʉ�ĉ�'Y�b��f�%���nF�CblaX ��ĂB�5�?�<�*�P��ֽ�y��u����!ls�O�����<~%��~�g�?��.�ŷ'E���?W������o���~G>Ǒ���������譣C�����5t1�ʟ~�Bѐ�H��*�X�
G�r�)IaM<#íA*dT�	�lK�!��_H�x���~��|���~��W~������䏞��8�{�],�;X��G�^�h��_����� ���z/��� ����?"_J���=|�0�O��v�m��{��n��b�S.Z�����n4Z>6�t,��z�l2,}�t:��~/�/X��,�
�-��W!>tUC`Zv�P؍��Z3�XsA��ٝ�V&6�.iB���B�@
��d=[��
�3DH	���N���HkQ(
&g���1[��ǍAl�h]�X74|��L\�����ns����L(�̈́	3�rs�k�T��*n6��i��B�4���E�y�W/��3^����3l��׏��iz���y͠:� S<���S|id�|�k��t"�.T���~�.�쬄��3%Y,SVF�+e�B3Y��"��)�����$����5?]O"L�A��	3�v�I�ْC�Y!��B')�yD�:)��"}.��F�4��05+��"S����yx���*�4߉/&=T+��.q�@汨F.��L��w��.����43���dMk�IJ�UKe�H'�Qz6nRbnn�'��X9�����������^�Mw�^"w�^"wE^"w^"w�]"w�]"wE]"w]"w�\"w�\"wE\"� ��0�.�f)E���O�J�Õ�Rb��9��7��x1���8��60�.��q/jgE�s�*'�K螻�<R�[��۩����@���������A\�S붗yj:Ċ�Hz�3D渁gC�iT�r���f	~����ܔ	�jiZ=G0��S�DY
7��&��	N���Hj��j�����&�'����8c+s�ٲ�#t-��Itoi⭈�Sf�[87/T?:5�r82�1J�a�C�9�)�fbX�vb��(N��<]�D��eS}BᒹӊJ��ܤ�Gd��J�~�̢Ԁ��˼[�w��ہ_8z=�A�(���G�=z��r�?� ���u���n�}���o���&���G��Z>	�s������G�N>��^�:5]���/z�����x#�ׁ�����[�(������+�o<��c>��������<��+EYfi�2YZ�|ވ�r��2y���r�b��ۭ-�/�/Z�'X����8���-3a�3I��Pr!���Ky������\�-�
&�qD�ilJ����]	���o� �D����tZ�������x�BH5J����Ȕ�S�cv�W������T��ln���z�X`��z�mQt|�TZ�8i�F�֣��6H�;*?NWFx�Dj"���L�x����+�4k9M�S���4K��� #�@��P!iAf;��3R�[T�F;*]n'���HĐ��sK�l=Qu�4_�/�SdMQv�)�e8Z�՚���k�&.v˃A�D�	�k9˂�`d-�~�l!���9m�����]f�tÚrܘ3U���-^�J�d�G����ǿu%�ā����B=��|yP�����δ[\n�����e��]���4�K���� �u�#�q��"��"��Y���j#�o?c�gf��e\vGn��.�#����u�{����7�ڴ���
G�[�e:��Ɇ�Vyc֑�|&Oԓ�8�Vla8,)�zܯ���X�.}6�0Ōb4��í��y���è���F��J��lV��*\�ڴe�6��M��6���x��Gt�:��Sȇ�N"5�u���8R힟Z{:��A�|�W:�dZ�R�%��b��҂4=mբy%٨(�T�/��1�.Efi�	�ys �7.5/E�a:��&S�v?�Ry.B�[Åip�X�1#�x�E��³��y%OdE�H+E"dg��xXS#S�1�+��-��l��U$#3I;�d�p�G����4�2An{�*de_�L$k;�*�"0�]�����W+�Rz*�+����X��R�C��Vp�	���c.���*�5
%�Cp�cq�K+ճ(�<Ki���M��et:S��;�
q5��)g��y�)�����E}h:��*��=����	җ�BJܐ��Ba�nF-E�N���|��r�J7D�V����l��5�T�Q���a2j��4�cSi�4���%��P6�-�F�U��r���.c&�.���_|˲���w��M7��ٍ�/Z���.�����<tlѢ���*8r3>�e�g�i�2ԧ��+����7��6�<F~���V��.��{����ϟ?�?|�<�����#ڎ���D� V�>E�΀oISeۇ�]�@\ӛĕ^)�y�y��t���:#��� ���#2�q>A~����)P��8�8uG�k��{�y䁳8�,O]W� x�|�`���ҡG��"�2+G�k��t�t�� Od̯����������H/���G/8���A����ד ���
�;��ts�����T�
�/�Vf��z�;�0V%���4���Ŏܸ��;
���4���3"�_���926ifw��]���H���I�S�k�*��9?�t�l�㧫���3�z�폭�U^Ѣת����U�ɎN��h���s�cj|oo==VG_Q�lH��z?<�HPP� !=����%-�8F�G10E�6��'
,Բ� z& 1�"v*�2H}c�]\ �3�w�ؤaв�S�� �fq.���Ի��&������ �˩O��/O��jNW@���+��V��&>$�MO��`������z�_ g�ADVТ3��1���X뭭u�v �w�W���h~�ʬ��A�|��,] R�̢�'���g�*�L�*�?Yu�b[�h���%���q��{��юW�]�Ip��:�z�"�gm�}��e�tb���2z��$��6�O�aKK�I�8�j8���jQ;�+��@��z!�g䊉+�������ԃ��?�0Ӱ�M���	�����* �.6��u��~�_�/�LF�}=w�_�1t[=:�� ��`S!z,-{�Q�k28� ނ��>�)OB�P��Zm6����6o(�� )�O◧q���粫k@W�g/"��B�m��p~в���dM`e�%�s%k�hٺ2�^���-%O�{��Q�� 8\�a�n]\*��/ ���P�$U�/cX%m �cp.�bz��v_�a�Nv �ݶ��^q�Eo���#�c��� �	����ӔT�=rQ�@�J�&(�񟅜	}�vp��,�]� _�.� Q�6����*�u�ii�~��@����`WV�ce2����C�&͝�\2�o�nZ�<�t;h�Y�$�s�>�n�	r�#��[�E ���D�4kX򪋫�=]�8�	�e��X4(0����.�lto�x����c��� �ކ�8m1���j�i"�-B���W�Z%kݶ�����jBH��:3r
����23��z�:��:�k�'ش_@���1���^�U�͉�	�C��	�z?붉�ֆ�Ɖ�S�9�a1b%)��������_��$�-4egCi�@'(�w���w\qpl��b��Iߑ���j�����
$��܏:�����������������m�����+���b3�'�`��}$��!>!>A@j˶Jv�ܰe%�vr��h �oó�g���"?��g 2�3T1Z�����Q��+\����*vt��R��Y��\��ծu��'���ӱrEC�\�f�H!K�I5	Ij���HdH	�m�j�ZJ�#m\��f��?F��v���p8�H%��}[�����DX�ì�gN,�*�����l�Ƕx�O�'O�Pa̐k�bǂxf��W7��IM����&�bY�qB	�0)&IE�cJ�RQ%$5eBB
Y3�)ሂK��X|Ҵ�����c3�D���̲��o���7�;�$�亣q��	Ovfߓ�E�V�]����wd��cw���msE�+ZT��\�Μer�W�2�d�9�\��/�\�f�"W*=àu�]��[�K'�r�3x�E�����_pa�A��P���3���U�A���.��{��U@@�[;�3�Π���vF�\�'-���i���Z�3��b��-��o�A�6io��;]k�nxl熉Bw�!���V7g�j}��nz��0�b�ߊ�y!��sEy��&��W� t�>���l<Ǯr�<�rL9���"�qY6����P���(
�Y�3i�N�CǶz������Yy��?��m�&<Z�����ZES���e|�,ˉ�\�T�F��e�3����F�X�>���d=�k��bj�g@�=fY-�&��%�9�'K�4C��gq�e.�ϕ�)�q����N�1��E�/�A=�-�O�8��L>kK��\����"�xc0��EL���:Mݝﯡ���,���vs��:߲]��d�X��`��2V��~��0���{�F.u���N���ͮ��;V�ߊw�#�9+3V���@!t����3��m����zq`�&�f�_�$9��G���o��6n��!�|'뿏���KF�f�CD?��>�+���ķ�c���H/��MoI�	zH{H�X�[�*t��{I���'plS����A��#�K�ß��i�ʦ}��K������_ �����hhh^���f��W��#w��:�{I���9&Y����E�v$*����l�Ȗ"K�X$��*�EۡV�����pTib���	�u��,��j�Wa���m���k/�g�m�ɼq�O�}\S��:iet�:G�+b�M	�;�4��u%?��8ɍ��$P=��E��"m.U���rH!2��@��E��-�=�ޖ�����y�?����ޤS)N�Z*^	a1eV��a�;F5��؟�����O���?���_z���Ɔ��8iw����������H���'�������Gڗ�� x���ʧ��?�����[�d$r���H�,�R����+��� ��]��������
�x ��D�O����.�Ij[�S����j��G�Jti_��2�g����?:|��?���KMl��+λc��/g������^� D�(*ʯ��*&���J*)؝��T1��(:�k���pT'�	Gu��G8H�?���'�T�_�C�_�������<� �W���Ck 
�?C<����[	ު��[�m>�*ݠ��y�qXw�N��K���?�Z�?CCJ����m������c��1޽�y[��޷�Y�דYL=�o�����,�`��¯VyC+��E��z�E���U�9�n��:Q̅�*�:_G���Z�a��
�E�j�'����=t��72������'�={�m���q�wȃztĝ��`^�))͞,m�^z��j��v���}ʗ���v�i꫱q���f�F�s�}#�h9��ʴ�{�X�ړu�2���a(���x������e��b���G����L$���k��eA,�z �����������R������'������O���O���O�	��
 ���$���� ����������_����H���o����B��������Z�_��L:�bz�,���:�n�����V�����u�����ƣ�!�}Y����:n�5�i@��`��CymĻ�`���H�i�ޣ���eB���FA�4I�B.���:cvN���>���no��ij�R�c��#����^}�	�Q,�ג~)�V���_��ؽ���m|�����u:!;%���;�ewŒ�HI��t�2��^2)�l�5���b"��3�ǋФ%i�_���	��V`�|�	��c�td�6���/��߀��#��?�_@@���K~H���5 ���[�����W�/��W��6.�3�,�Yb��L@��B���|R,�\HRA�S!2�@x�����Y�?����g���e�ӗ�DJ�V�d�<��Ӿ��Fԩ�,[�dm�S����3{{���S�.�#�Tݽ�ّ��66]���jrX�p�.6[J�=��y�&������� k�L�>�ó��:����@���������a]�Z���������Om@��_��2���7
��_}����ѴT稫��vs����3�uW��n���;����S{�WGr<h&�o^r�+df��Ses��;	e����*ƇqN��TqGv�.����p��`�<�-U�u���߷��?	�oM@�����_��7 ��/������_���_�������X�����(�_xK�y�U�����ALڲ�G�̈́�BM���!���%��g����v�cW����3 ��� ��z�� W��G�p)>U����7� ��<���.6�CJ�e�%W���ϱA�Ք�n��Zۥm+ö\�d#6���ODu�����^>�wUo�~)���f{a�Ş�Dߍ�OO����|�� �ے
C��{)V[�U|b��蓾�i�� 2ۧ��<Q��H*7X��9�Sv?7iW�9~�@���!5��VZ{�x~�I�&���x�@(�%k�H���1k5�ٱ[�Rc:�;R�L���b);��Ft�/�=1���Ќ��\d�ׇMjt��ag��">K&�_VNW��E�P��D�Ѡ������C&<�E�����8��p�T��ğ�`��T����,��������������������_o���5��G~�2~8���̟dD��/��ϲ�q8�����i>E�3^�h."|֏`��ÀB��l���O%���^?8�J-s��f�9$�$9��Y1za�Ftɚ�ZL�i��*�$���ŶKzi�[����]�?5�!��PR?K6�~��Iua�7�ˈ�E�^K�:g�ǎẤ��e��Zξ�S���~+P���������������%��P�����R��U 	�g������?�$��"��������U����P9���/�����*����w���
���~�����o��ߎ��e֔ڗt�%��Z[��aY���"���o�4؏�~��~d������q��(��xx�ǌ��S-y؛���#��%�h�ζc��މ3'�T/��,����J�mo5q�;��������$��y��
oڜ�����h�Ҏ}�8R��6v��*�Y�kۉ�o�6{�?r�&	�~�[�f�m�(��~��-�H�.ӡ}��8����ʚ%ӹn���ƻ��F4�3����������-F�I�5c-��M7f�2K[����Vw�����|<�ȴ��f�;�ˮ(迫ڃ�kB5��wGP�����'	
�_kB���������7KA�_%��o����o����?迏��u ������(�?���C����%� � ���I�/EC�_ ��!�����?���A�U��������y��������������$�?����������m�n �����p�w]���!�f �����ē���� ��p���_;�3O����J��C8Dը���7�����J ��� ������x�a��" ��`3�F@��{�?$��y�� ���?��� ��g�4�?T�����������I�A8D������H�?��kZ��U���I��� � �� ����������J���˓��������C��_��8�� ��0�_9P��a��>��?���������! ���'�� �W����}������(�?��{��(�?A\�`�G���)���B4����+I����C��C��9_������G��]���K@�_�T����Z�GW����ݹV��?U�R/��7`Y1�kE�'�i��U�b^_�61���x�>�[J�C�ڒ��P4eQ�Orn��03�U��e�Q�荼NAc�h�^�!saZ�qG����b�u����Ɉ�C����KO�8x��$c�����I���#����Yj������(�����H�?��������q-�~1~C���P�Շ�Y�B�`΍C�)Z���a�Foɝ�`V���"��E�ԭ���s���>�k�l���C��m����5�,p�<f�Gg���vMwz����].�ٹ-�;C�)2kFN��Q�m���ʘP�}+и�?���oE@�����_��7 ��/������_���_�������X����3�����-����k�R7Q�X޳[{b��/�V���V���߫��I;E�$�Md��ľ%��z�~�9a���V���4b�C��L	v�D��ph�'�݋�,>��c}�.Ų<�9���%��lF�����fn��{�v���+}��{�t�m��r[RaH���^�Ֆt�߉K���\蓾�i�� 2ۧ��<Q��H*7���9�Sv?7iW��B�P-Y�p���	����D0�T�ϴ��<��͹w����(4ڽ�����'3��
=?ՈY�Z3A$�8�L�Ft�Q��|�1���ﯻ+�����g���[�׿����8GB��|�����������p�� 
�A?�����J�џ��D7�BU\���'8��*���8�������@5����	��*�����k���I��*��g:�,�._�?󴱲�$�!H��§��\(?;�����=�C&�n��E��qS�?��+]c�=��h/���s?����
5���-_[��!�w�rx�.o��-��sl��)?9����u5$�����-e��P��Fή큊}=ި�^m�L�sq>&��g�ZL�e��-
��l2ҡG���u�ѢM�K�xJ0�\�S�/&��m��/Vދ��O������R<Uo_��8��~��7;ׇ�NӐ_�3%�I�8�7uvTC�v۲�#b�o+�i,#�*{l��F���e�͎�H��H䢗ؼD�t����`f���9�d"��i��k����n�Z,%nӗ
�<ŏ�&(�=��ԦB�/��c��+����~w �����?��V�j�0x��ps��I_�S!�_��P��4���|r4%�}�ؐ	�(?�Cb������������J�3��6���p�I�pL�f��(���1�v�h��������\��Z��#Wnj�����������0�_@A�������|���CU\�7�?�q���W	���z�����ځ?��<���b��p������;��a��4P�̋�w3ذ�y���~؏x7���obH�����}���}��gQ���XRI�:ܑ��nC�Qkia;��'}&l����`�i$|�%�"dEyDa����٣Ŝ���ɦՍ-�n��^��n�aO|??P�M"��8�y�!�w���N���E���t1��u��'&��L��,��fD�N4��դ-Qb�	�V�Y�E��ןj�u��2'�i-�u��N��X[v�f�k���h�b���~w����g�?��[	*��3>�a��<�Ss�$o���~�pQ4�'|����߄W]0�	��I��>B������������������_��n�6-��v�i��gz��q�自h�Y9�$�����-7Ղ�W���������-���G���U��U�=�?�_�����v�G$��_7�C�W}���_c ���������?GB�_	���ȷ������ִ��4wc�^O�{�<>.����O�pI��?��>��U�������\�C��"��(�J��b.Ջ��.�:�>��>�|~�-�޽s���uu�\a/GW.����w�Ojb�������:uny�y�CO��*@E�}��u+���N��~��N:љtf�l&�OU�v�[���^k���kV���>^���Jxa/�<���i9�Bg\�D{[[w:�T��hV�n�l=����}s|��*&��h�6�2�rڶ�t��H�1k	\�m����J	/Sh
�y���y�G�)q�<��n�x�=���gw;�b�ꇽ��v~��6lIi6F�í2�%Ym^���'�u����vcR��ld���j0��U���UL,ZJ�Ѷ�f�~���#ؕS�벵��R��p�qT��J%)�H]�+����|ß&�um�o��Ʉ,�C�?�����_��BG�����#��e�'_���L��O����O������ު���!�\��m�y���GG����rF.����o����&@�7���ߠ����-����_���-������gH���!��_�������_��C��@�A������_��T�����v ������E����(��B�����3W��@�� '�u!���_����� �����]ra��W�!�#P�����o��˅�/�?@�GF�A�!#���/�?$��2�?@��� �`�쿬�?����o��˅���?2r��P���/�?$���� ������h�������L@i�����������\�?s���eB>���Q�����������K.�?���D���V�1������߶���/R�?�������)�$�?g5���<7׭2m2��ͭb�5M�dR�����d˘d��ɱ÷�uz��E������lx��wz�(q��Fu����u��
M�)�ǭ�o2��wY��^�պ(����t�6ǝ6&w�Ɋ~HS,��8�m��/k��Ȏ�d�)-zB:]=h�V�E�Gu:,�q;,����m����d�U��\OS���՛�nǮU#�rEy�'����$YG���Wd�W�����E�n𜑇���U��a�7���y���AJ�?�}��n��%��:~��'jv��w�^���b�Q�ˆ��m��m��E��Ξ����Fu�j�[��j���#��͆�6,E�D8��~],���ߪb۰�sUk��ɫ�v��]mN���&�P;z��%�����7�{#��/D.� ����_���_0���������.��������_����n�QP�C��zVa��U���?��W��p���)VĚ8�)__�_ف����6��h�@*���z�.K�l�?���E��5}4o����D�0.L�x\��!iͱS��ˉI�U'�N��z�����~Q�j�J)l�[m,���m
��:;���_e�*��і����D�Z�F�1M!��bwXO����h�IJ�}v~s��V�~������^�|Jb���*P���r��KQ]٨5�V���v9X��ͦ2⇃8?LKQUZ�X�8���N�Y2D{�����qqېI�]?hB����|/Ƀ�G�P�	o��?� �9%���[�����Y������Y���?�xY������������Y������&��n�����SW�`�'����E�Q��-���\��+���	y���=Y����L�?��x{��#�����K.�?���/������ ���m���X���X�	������_
�?2���4�C����D�}{:bG[U�7��q������0�Z�)�#fs?��
����s?���L�G����"�w��Ϲ�������uy�ݢ��]�D�����8�P�;fm���\����j�7��O�gCvfNcap���M#��8:�!,Y��dSSmG��Q����Ѽ��_�Jޯ�WOG���\�F��4��
�}8V�����tu���_����Ug"��`1�lF90'<���%ik��Nt��jX#9jSo�}2�V,�X���`�fa�w��ReCi��DpT���vra���?2��/G�����m��B�a�y��Ǘ0
�)�������`�?������_P������"���G�7	���m��B�Y�9��+{� �[������-��RI��_�T�c�Q_D��q��Hmك�d�S����>�ǲ�<<�����،��i
���=��)������0��ыFI�h���z~��T�i��,u��7CS��W�*G}���hA�F�P/rq{+��eY!F�o� `i�����$�����B�{�X�/t)E�W��|aʜ�b�-?
�¢��nkO�����lX޴��P�G&��^S:K�X�!m�WЭ	�m�������?L.�?���/P�+���G��	���m��A��ԕ��E��,ȏ�3e�7�"oY�fh�f΋�N[,�s�N��E�d�l��a�OZk�:ϙ�O�9�c�V���L�������?r��?�������O�H&O��Q�Q�Nf��j�j�4*���<�ބ&{�`��Vb�埈`g��kL^�J���������ʝJ]X��5rr�4׉Y<�ZV p�|��n4��?_K���������q�������\�?�� ��?-������&Ƀ����������z�X�􎬊Ĝ�*Ċ��K���[Q�Ew��/�N��>�\_:���`K��_a;�YRL=4�,�G�~u�N�����[�iW||Ռڲn0.O������&^����24��%��E��3��g����``��"���_���_���?`���y��X��"�e��S�ϖ>�����ct�\���t/B�����S�����X �������wں�E[M�$������q��tc����r�J̧2�"��rV�#��'�`�)��Byh�X��a���שҬ�ڶ��RW�/�<,��DM���';O|�V�OE�;�q:&�BwX��u� v-a��$:9�6�RIv��������my�(�+�*"c���=QJ��S�M��MԵ�_�S��i�򳽈}U8P��Hԫ+��u��ˆď䓻p��J��ڞ[���b�n�0Fb��*4��Â�S�}�1�Յި���|8ezTqZ&�r�w��#O�9��}tx]���'����B�i&��?�ݹm�x������:��_v��Gm�(�����	bO�>J5�cG�?��+�y����<�Y���t�Ϧ��|L������]$�=c��������{=���G�����CI�������5�L�X���R��7?�%�����?}J����p�}���?�㾊��i>�����������.0�ox��D����n���Ǎpm�N������{,4#���'縉�i$����I_�zR��v��I�d���r��x�0qcfr��${{��(����7�x�#����w��~�c�=�I��%���w�����w܏�ɫ���[~I��OO;v������<Q�T ���;�r��}u��������<��XK����~��`m�m3�Ϗy��ӕ�渆�޳�M��"�`纎k��DނO��?q'w&�� �Bo�q�4����ÿ�Z�~����f�?�i,<��/���צ�������{��$�|��9��f@�{�M�t����?n�q��W��œ,���67aF���x�s�pM�ӓU=���SJZ��E�qwɍ'�{Տ�j�����H�VM�;���Hva*�����t�w�j�ez�w�ח������=q�}                           p���m� � 
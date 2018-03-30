#!/bin/sh
echo '****************************************************************************'
echo '              copy_mavens.sh                                                  '
echo '                      by zhanhaibin                                         '
echo '                           2017.12.27                                       '
echo '  说明：                                                                    '
echo '    1. 把maven的jar包，拷贝到~/.m2/文件夹下。                           '
echo '    2. 参数1，工作目录。                                                    '
echo '****************************************************************************'

mkdir -p ~/.m2/repository
cp -r repository/ ~/.m2/

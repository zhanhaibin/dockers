# DEMO
docker run --name=testsamlidp_idp \
-p 8080:8080 \
-p 8443:8443 \
-e SIMPLESAMLPHP_SP_ENTITY_ID=http://app.example.com \
-e SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE=http://localhost/simplesaml/module.php/saml/sp/saml2-acs.php/test-sp \
-e SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE=http://localhost/simplesaml/module.php/saml/sp/saml2-logout.php/test-sp \
-d kristophjunge/test-saml-idp

# 启动docker idp  测试app.avacloud.com.cn
docker run --name=testsamlidp_idp2 \
-p 8081:8080 \
-p 8444:8443 \
-e SIMPLESAMLPHP_SP_ENTITY_ID=https://app.avacloud.com.cn/wp-content/plugins/miniorange-saml-20-single-sign-on/ \
-e SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE=https://app.avacloud.com.cn \
-e SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE=http://localhost/simplesaml/module.php/saml/sp/saml2-logout.php/test-sp \
-v /home/simplesamlphp/project/authsources.php:/var/www/simplesamlphp/config/authsources.php \
-d kristophjunge/test-saml-idp

# 启动docker idp  测试byd
docker run --name=testsamlidp_idp \
-p 8080:8080 \
-p 8443:8443 \
-e SIMPLESAMLPHP_SP_ENTITY_ID=HTTPS://my601294-sso.sapbyd.cn \
-e SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE=https://my601294-sso.sapbyd.cn/sap/saml2/sp/acs \
-e SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE=https://my601294-sso.sapbyd.cn/sap/saml2/sp/slo \
-v /home/simplesamlphp/project/authsources.php:/var/www/simplesamlphp/config/authsources.php \
-d kristophjunge/test-saml-idp
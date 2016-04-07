all:
	./convert_linux.sh `git rev-parse --abbrev-ref HEAD`.xsl

release:
	./convert_linux.sh SI-UBL-INV.xsl

# This is the Generic coreboot target

ifeq ($(CONFIG_PLATFORM),y)
ifeq ($(CBV2_TAG),)
$(error You need to specify a version to pull in your platform config)
else
$(warning You specified $(CBV2_TAG) a version to pull in your platform config)
endif
endif

CBV2_BASE_DIR=svn
CBV2_URL=svn://coreboot.org/repos/trunk/coreboot-v2
CBV2_TARBALL=coreboot-svn-$(CBV2_TAG).tar.gz
CBV2_PAYLOAD_TARGET=$(CBV2_BUILD_DIR)/payload.elf
VSA_URL=http://www.amd.com/files/connectivitysolutions/geode/geode_lx/
CBV2_VSA=lx_vsa.36k.bin
TARGET_ROM = $(COREBOOT_VENDOR)-$(COREBOOT_BOARD).rom

include $(PACKAGE_DIR)/coreboot-v2/coreboot.inc

$(SOURCE_DIR)/$(CBV2_VSA):
	@ echo "Fetching the VSA code..."
	wget -P $(SOURCE_DIR) $(VSA_URL)/$(CBV2_VSA).gz  -O $@

$(SOURCE_DIR)/$(CBV2_TARBALL): 
	@ echo "Fetching the coreboot rev $(CBV2_TAG) code..."
	@ mkdir -p $(SOURCE_DIR)/coreboot
	@ $(BIN_DIR)/fetchsvn.sh $(CBV2_URL) $(SOURCE_DIR)/coreboot \
	$(CBV2_TAG) $(SOURCE_DIR)/$(CBV2_TARBALL) \
	> $(CBV2_FETCH_LOG) 2>&1

# Special rule - append the VSA

$(OUTPUT_DIR)/$(TARGET_ROM): $(CBV2_OUTPUT) $(SOURCE_DIR)/$(CBV2_VSA)
	@ mkdir -p $(OUTPUT_DIR)
	@ cat $(SOURCE_DIR)/$(CBV2_VSA) $(CBV2_OUTPUT) > $@
	
coreboot: $(OUTPUT_DIR)/$(TARGET_ROM)
coreboot-clean: generic-coreboot-clean
coreboot-distclean: generic-coreboot-distclean

-- CreateTable
CREATE TABLE "spare_parts"."categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "parentId" TEXT,
    "level" INTEGER NOT NULL DEFAULT 1,
    "path" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "imageUrl" TEXT,
    "properties" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."suppliers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "supplierType" TEXT NOT NULL DEFAULT 'OEM',
    "contactPerson" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "website" TEXT,
    "address" TEXT,
    "city" TEXT,
    "state" TEXT,
    "country" TEXT NOT NULL DEFAULT 'India',
    "pinCode" TEXT,
    "gstNumber" TEXT,
    "panNumber" TEXT,
    "paymentTerms" TEXT,
    "creditLimit" DOUBLE PRECISION DEFAULT 0,
    "creditDays" INTEGER DEFAULT 30,
    "discountPercent" DOUBLE PRECISION DEFAULT 0,
    "minOrderValue" DOUBLE PRECISION DEFAULT 0,
    "deliveryTime" INTEGER,
    "rating" DOUBLE PRECISION DEFAULT 0,
    "onTimeDelivery" DOUBLE PRECISION DEFAULT 0,
    "qualityRating" DOUBLE PRECISION DEFAULT 0,
    "totalOrders" INTEGER NOT NULL DEFAULT 0,
    "completedOrders" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPreferred" BOOLEAN NOT NULL DEFAULT false,
    "isBlacklisted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "suppliers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."supplier_contacts" (
    "id" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "designation" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "whatsapp" TEXT,
    "department" TEXT,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "supplier_contacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."spare_parts" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "partNumber" TEXT NOT NULL,
    "oemPartNumber" TEXT,
    "internalCode" TEXT NOT NULL,
    "description" TEXT,
    "categoryId" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,
    "compatibility" TEXT NOT NULL,
    "specifications" TEXT,
    "dimensions" TEXT,
    "weight" DOUBLE PRECISION,
    "material" TEXT,
    "color" TEXT,
    "warranty" INTEGER,
    "costPrice" DOUBLE PRECISION NOT NULL,
    "sellingPrice" DOUBLE PRECISION NOT NULL,
    "mrp" DOUBLE PRECISION NOT NULL,
    "markupPercent" DOUBLE PRECISION NOT NULL DEFAULT 20,
    "unitOfMeasure" TEXT NOT NULL DEFAULT 'PCS',
    "minimumStock" INTEGER NOT NULL DEFAULT 10,
    "maximumStock" INTEGER NOT NULL DEFAULT 100,
    "reorderLevel" INTEGER NOT NULL DEFAULT 20,
    "reorderQuantity" INTEGER NOT NULL DEFAULT 50,
    "leadTimeDays" INTEGER NOT NULL DEFAULT 7,
    "qualityGrade" TEXT NOT NULL DEFAULT 'A',
    "isOemApproved" BOOLEAN NOT NULL DEFAULT false,
    "certifications" TEXT,
    "imageUrls" TEXT,
    "documentUrls" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isDiscontinued" BOOLEAN NOT NULL DEFAULT false,
    "isHazardous" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "spare_parts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."inventory_levels" (
    "id" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "storeName" TEXT NOT NULL,
    "currentStock" INTEGER NOT NULL DEFAULT 0,
    "reservedStock" INTEGER NOT NULL DEFAULT 0,
    "availableStock" INTEGER NOT NULL DEFAULT 0,
    "damagedStock" INTEGER NOT NULL DEFAULT 0,
    "minimumStock" INTEGER NOT NULL DEFAULT 10,
    "maximumStock" INTEGER NOT NULL DEFAULT 100,
    "reorderLevel" INTEGER NOT NULL DEFAULT 20,
    "reorderQuantity" INTEGER NOT NULL DEFAULT 50,
    "rackNumber" TEXT,
    "shelfNumber" TEXT,
    "binLocation" TEXT,
    "lastCountDate" TIMESTAMP(3),
    "lastMovementDate" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "inventory_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."stock_movements" (
    "id" TEXT NOT NULL,
    "stockLevelId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "movementType" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "previousStock" INTEGER NOT NULL,
    "newStock" INTEGER NOT NULL,
    "unitCost" DOUBLE PRECISION,
    "totalValue" DOUBLE PRECISION,
    "referenceType" TEXT,
    "referenceId" TEXT,
    "reason" TEXT,
    "notes" TEXT,
    "createdBy" TEXT NOT NULL,
    "approvedBy" TEXT,
    "movementDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stock_movements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."purchase_orders" (
    "id" TEXT NOT NULL,
    "orderNumber" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "storeName" TEXT NOT NULL,
    "orderDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expectedDate" TIMESTAMP(3),
    "deliveryDate" TIMESTAMP(3),
    "subtotal" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "taxAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "discountAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "urgencyLevel" TEXT NOT NULL DEFAULT 'NORMAL',
    "notes" TEXT,
    "terms" TEXT,
    "createdBy" TEXT NOT NULL,
    "approvedBy" TEXT,
    "receivedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "purchase_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."purchase_order_items" (
    "id" TEXT NOT NULL,
    "purchaseOrderId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "orderedQuantity" INTEGER NOT NULL,
    "receivedQuantity" INTEGER NOT NULL DEFAULT 0,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "purchase_order_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."goods_receiving" (
    "id" TEXT NOT NULL,
    "purchaseOrderId" TEXT NOT NULL,
    "receivingNumber" TEXT NOT NULL,
    "receivingDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "receivedBy" TEXT NOT NULL,
    "qualityChecked" BOOLEAN NOT NULL DEFAULT false,
    "qualityCheckedBy" TEXT,
    "qualityNotes" TEXT,
    "qualityRating" INTEGER,
    "invoiceNumber" TEXT,
    "invoiceDate" TIMESTAMP(3),
    "invoiceAmount" DOUBLE PRECISION,
    "transportDetails" TEXT,
    "packingListUrl" TEXT,
    "status" TEXT NOT NULL DEFAULT 'RECEIVED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "goods_receiving_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."goods_receiving_items" (
    "id" TEXT NOT NULL,
    "goodsReceivingId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "orderedQuantity" INTEGER NOT NULL,
    "receivedQuantity" INTEGER NOT NULL,
    "acceptedQuantity" INTEGER NOT NULL,
    "rejectedQuantity" INTEGER NOT NULL,
    "condition" TEXT NOT NULL DEFAULT 'GOOD',
    "rejectionReason" TEXT,
    "notes" TEXT,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "goods_receiving_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."service_requests" (
    "id" TEXT NOT NULL,
    "ticketNumber" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "vehicleNumber" TEXT,
    "technicianId" TEXT NOT NULL,
    "technicianName" TEXT,
    "serviceType" TEXT NOT NULL,
    "priority" TEXT NOT NULL DEFAULT 'Medium',
    "status" TEXT NOT NULL DEFAULT 'Open',
    "description" TEXT,
    "storeId" TEXT NOT NULL,
    "storeName" TEXT,
    "serviceAdvisorId" TEXT,
    "estimatedCost" DOUBLE PRECISION DEFAULT 0,
    "actualCost" DOUBLE PRECISION DEFAULT 0,
    "partsCost" DOUBLE PRECISION DEFAULT 0,
    "laborCost" DOUBLE PRECISION DEFAULT 0,
    "scheduledDate" TIMESTAMP(3),
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "externalServiceId" TEXT,
    "jobCardNumber" TEXT,
    "customerName" TEXT,
    "customerPhone" TEXT,
    "vehicleServiceRequestId" TEXT,
    "vehicleServiceStatus" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."spare_part_requests" (
    "id" TEXT NOT NULL,
    "serviceRequestId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "requestedBy" TEXT NOT NULL,
    "requestedQuantity" INTEGER NOT NULL,
    "urgency" TEXT NOT NULL DEFAULT 'Normal',
    "justification" TEXT NOT NULL,
    "estimatedCost" DOUBLE PRECISION,
    "status" TEXT NOT NULL DEFAULT 'Pending',
    "approvalLevel" INTEGER NOT NULL DEFAULT 1,
    "currentApprover" TEXT,
    "approvedBy" TEXT,
    "approvedAt" TIMESTAMP(3),
    "rejectedBy" TEXT,
    "rejectedAt" TIMESTAMP(3),
    "rejectionReason" TEXT,
    "issuedQuantity" INTEGER DEFAULT 0,
    "issuedBy" TEXT,
    "issuedAt" TIMESTAMP(3),
    "issuedCost" DOUBLE PRECISION,
    "batchNumbers" TEXT,
    "returnedQuantity" INTEGER DEFAULT 0,
    "returnedBy" TEXT,
    "returnedAt" TIMESTAMP(3),
    "returnReason" TEXT,
    "returnCondition" TEXT,
    "technicianNotes" TEXT,
    "approverNotes" TEXT,
    "issuerNotes" TEXT,
    "vehicleServiceRequestId" TEXT,
    "vehicleServicePartsRequestId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "spare_part_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."approval_history" (
    "id" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "level" INTEGER NOT NULL,
    "approverId" TEXT NOT NULL,
    "approverName" TEXT,
    "approverRole" TEXT,
    "decision" TEXT NOT NULL,
    "comments" TEXT,
    "conditions" TEXT,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),
    "escalatedAt" TIMESTAMP(3),
    "requestValue" DOUBLE PRECISION,
    "availableStock" INTEGER,

    CONSTRAINT "approval_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."stock_reservations" (
    "id" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "inventoryLevelId" TEXT NOT NULL,
    "reservedQuantity" INTEGER NOT NULL,
    "reservedBy" TEXT NOT NULL,
    "reservedFor" TEXT NOT NULL,
    "reservationReason" TEXT NOT NULL DEFAULT 'Service Request',
    "status" TEXT NOT NULL DEFAULT 'Active',
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "releasedAt" TIMESTAMP(3),
    "releasedBy" TEXT,
    "releaseReason" TEXT,
    "reservedCost" DOUBLE PRECISION,
    "actualCost" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stock_reservations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."installed_parts" (
    "id" TEXT NOT NULL,
    "serviceRequestId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "technicianId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "batchNumber" TEXT,
    "serialNumber" TEXT,
    "quantity" INTEGER NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "sellingPrice" DOUBLE PRECISION,
    "totalRevenue" DOUBLE PRECISION,
    "installedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "installationNotes" TEXT,
    "replacedPartId" TEXT,
    "replacementReason" TEXT,
    "warrantyMonths" INTEGER,
    "warrantyExpiry" TIMESTAMP(3),
    "warrantyTerms" TEXT,
    "warrantyProvider" TEXT,
    "removalDate" TIMESTAMP(3),
    "removalReason" TEXT,
    "removedBy" TEXT,
    "removalNotes" TEXT,
    "expectedLife" INTEGER,
    "actualLife" INTEGER,
    "failureReason" TEXT,
    "qualityChecked" BOOLEAN NOT NULL DEFAULT false,
    "qualityRating" INTEGER,
    "complianceCertified" BOOLEAN NOT NULL DEFAULT false,
    "vehicleServiceRequestId" TEXT,
    "vehicleServicePartsUsedId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "installed_parts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."service_cost_breakdown" (
    "id" TEXT NOT NULL,
    "serviceRequestId" TEXT NOT NULL,
    "partsCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "partsMarkup" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "partsTotal" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "laborHours" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "laborRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "laborCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "laborMarkup" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "laborTotal" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "overheadCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "miscCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "transportCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "subtotal" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "discountPercent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "discountAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "taxPercent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "taxAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalRevenue" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "netMargin" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "marginPercent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "calculatedBy" TEXT NOT NULL,
    "calculatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approvedBy" TEXT,
    "approvedAt" TIMESTAMP(3),
    "notes" TEXT,
    "breakdown" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_cost_breakdown_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."technician_limits" (
    "id" TEXT NOT NULL,
    "technicianId" TEXT NOT NULL,
    "technicianName" TEXT,
    "storeId" TEXT,
    "categoryId" TEXT,
    "sparePartId" TEXT,
    "limitType" TEXT NOT NULL DEFAULT 'VALUE',
    "maxValuePerRequest" DOUBLE PRECISION,
    "maxQuantityPerRequest" INTEGER,
    "maxValuePerDay" DOUBLE PRECISION,
    "maxValuePerMonth" DOUBLE PRECISION,
    "requiresApproval" BOOLEAN NOT NULL DEFAULT true,
    "approverLevel" INTEGER NOT NULL DEFAULT 1,
    "autoApproveBelow" DOUBLE PRECISION,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "effectiveFrom" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "effectiveTo" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "technician_limits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."part_price_history" (
    "id" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "costPrice" DOUBLE PRECISION NOT NULL,
    "sellingPrice" DOUBLE PRECISION NOT NULL,
    "mrp" DOUBLE PRECISION NOT NULL,
    "markupPercent" DOUBLE PRECISION NOT NULL,
    "changeReason" TEXT,
    "effectiveDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "changedBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "part_price_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."supplier_price_history" (
    "id" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,
    "sparePartId" TEXT NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "minimumOrder" INTEGER,
    "discountTiers" TEXT,
    "effectiveFrom" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "effectiveTo" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "supplier_price_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."inventory_analytics" (
    "id" TEXT NOT NULL,
    "periodType" TEXT NOT NULL,
    "periodDate" TIMESTAMP(3) NOT NULL,
    "storeId" TEXT,
    "storeName" TEXT,
    "totalItems" INTEGER NOT NULL DEFAULT 0,
    "totalValue" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalCostValue" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "lowStockItems" INTEGER NOT NULL DEFAULT 0,
    "outOfStockItems" INTEGER NOT NULL DEFAULT 0,
    "excessStockItems" INTEGER NOT NULL DEFAULT 0,
    "totalInbound" INTEGER NOT NULL DEFAULT 0,
    "totalOutbound" INTEGER NOT NULL DEFAULT 0,
    "totalAdjustments" INTEGER NOT NULL DEFAULT 0,
    "stockTurnover" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalPurchases" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalSales" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalMargin" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "averageMargin" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "fastMovingItems" INTEGER NOT NULL DEFAULT 0,
    "slowMovingItems" INTEGER NOT NULL DEFAULT 0,
    "deadStockItems" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "inventory_analytics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."sales_analytics" (
    "id" TEXT NOT NULL,
    "periodType" TEXT NOT NULL,
    "periodDate" TIMESTAMP(3) NOT NULL,
    "storeId" TEXT,
    "categoryId" TEXT,
    "totalSales" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalMargin" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalTransactions" INTEGER NOT NULL DEFAULT 0,
    "averageTransactionValue" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "topSellingPartId" TEXT,
    "topProfitablePartId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sales_analytics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spare_parts"."system_config" (
    "id" TEXT NOT NULL,
    "configKey" TEXT NOT NULL,
    "configValue" TEXT NOT NULL,
    "description" TEXT,
    "configType" TEXT NOT NULL DEFAULT 'STRING',
    "isRequired" BOOLEAN NOT NULL DEFAULT false,
    "defaultValue" TEXT,
    "validationRule" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "system_config_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categories_code_key" ON "spare_parts"."categories"("code");

-- CreateIndex
CREATE UNIQUE INDEX "suppliers_code_key" ON "spare_parts"."suppliers"("code");

-- CreateIndex
CREATE UNIQUE INDEX "spare_parts_partNumber_key" ON "spare_parts"."spare_parts"("partNumber");

-- CreateIndex
CREATE UNIQUE INDEX "spare_parts_internalCode_key" ON "spare_parts"."spare_parts"("internalCode");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_levels_sparePartId_storeId_key" ON "spare_parts"."inventory_levels"("sparePartId", "storeId");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_orders_orderNumber_key" ON "spare_parts"."purchase_orders"("orderNumber");

-- CreateIndex
CREATE UNIQUE INDEX "goods_receiving_receivingNumber_key" ON "spare_parts"."goods_receiving"("receivingNumber");

-- CreateIndex
CREATE UNIQUE INDEX "service_requests_ticketNumber_key" ON "spare_parts"."service_requests"("ticketNumber");

-- CreateIndex
CREATE UNIQUE INDEX "service_cost_breakdown_serviceRequestId_key" ON "spare_parts"."service_cost_breakdown"("serviceRequestId");

-- CreateIndex
CREATE UNIQUE INDEX "technician_limits_technicianId_categoryId_sparePartId_key" ON "spare_parts"."technician_limits"("technicianId", "categoryId", "sparePartId");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_analytics_periodType_periodDate_storeId_key" ON "spare_parts"."inventory_analytics"("periodType", "periodDate", "storeId");

-- CreateIndex
CREATE UNIQUE INDEX "sales_analytics_periodType_periodDate_storeId_categoryId_key" ON "spare_parts"."sales_analytics"("periodType", "periodDate", "storeId", "categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "system_config_configKey_key" ON "spare_parts"."system_config"("configKey");

-- AddForeignKey
ALTER TABLE "spare_parts"."categories" ADD CONSTRAINT "categories_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "spare_parts"."categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."supplier_contacts" ADD CONSTRAINT "supplier_contacts_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "spare_parts"."suppliers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."spare_parts" ADD CONSTRAINT "spare_parts_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "spare_parts"."categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."spare_parts" ADD CONSTRAINT "spare_parts_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "spare_parts"."suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."inventory_levels" ADD CONSTRAINT "inventory_levels_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."stock_movements" ADD CONSTRAINT "stock_movements_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."stock_movements" ADD CONSTRAINT "stock_movements_stockLevelId_fkey" FOREIGN KEY ("stockLevelId") REFERENCES "spare_parts"."inventory_levels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."purchase_orders" ADD CONSTRAINT "purchase_orders_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "spare_parts"."suppliers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."purchase_order_items" ADD CONSTRAINT "purchase_order_items_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "spare_parts"."purchase_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."purchase_order_items" ADD CONSTRAINT "purchase_order_items_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."goods_receiving" ADD CONSTRAINT "goods_receiving_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "spare_parts"."purchase_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."goods_receiving_items" ADD CONSTRAINT "goods_receiving_items_goodsReceivingId_fkey" FOREIGN KEY ("goodsReceivingId") REFERENCES "spare_parts"."goods_receiving"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."goods_receiving_items" ADD CONSTRAINT "goods_receiving_items_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."spare_part_requests" ADD CONSTRAINT "spare_part_requests_serviceRequestId_fkey" FOREIGN KEY ("serviceRequestId") REFERENCES "spare_parts"."service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."spare_part_requests" ADD CONSTRAINT "spare_part_requests_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."approval_history" ADD CONSTRAINT "approval_history_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "spare_parts"."spare_part_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."stock_reservations" ADD CONSTRAINT "stock_reservations_inventoryLevelId_fkey" FOREIGN KEY ("inventoryLevelId") REFERENCES "spare_parts"."inventory_levels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."stock_reservations" ADD CONSTRAINT "stock_reservations_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "spare_parts"."spare_part_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."stock_reservations" ADD CONSTRAINT "stock_reservations_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."installed_parts" ADD CONSTRAINT "installed_parts_serviceRequestId_fkey" FOREIGN KEY ("serviceRequestId") REFERENCES "spare_parts"."service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."installed_parts" ADD CONSTRAINT "installed_parts_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."service_cost_breakdown" ADD CONSTRAINT "service_cost_breakdown_serviceRequestId_fkey" FOREIGN KEY ("serviceRequestId") REFERENCES "spare_parts"."service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."part_price_history" ADD CONSTRAINT "part_price_history_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."supplier_price_history" ADD CONSTRAINT "supplier_price_history_sparePartId_fkey" FOREIGN KEY ("sparePartId") REFERENCES "spare_parts"."spare_parts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spare_parts"."supplier_price_history" ADD CONSTRAINT "supplier_price_history_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "spare_parts"."suppliers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

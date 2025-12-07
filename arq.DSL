workspace "Broadleaf Commerce Framework" "Diagrama C4 do repositório Git - apenas os módulos do framework" {

    model {
        # Desenvolvedores que usam o framework
        developer = person "Desenvolvedor" "Usa o framework Broadleaf para criar aplicações e-commerce"
        
        # Este é o repositório Git - apenas o framework
        broadleafFramework = softwareSystem "Broadleaf Commerce Framework" "Framework e-commerce em Java/Spring (repositório Git)" {
            
            # Core Module (projeto Maven core/)
            coreModule = container "Core Module" "Lógica de negócio principal do framework" "Java, Spring, JPA/Hibernate" "Framework Module" {
                # Catalog
                catalogService = component "Catalog Service" "Gerenciamento de produtos, categorias, SKUs" "Spring Service"
                catalogEntities = component "Catalog Entities" "Product, Category, Sku, etc" "JPA Entities"
                
                # Order
                orderService = component "Order Service" "Gerenciamento de pedidos e carrinho" "Spring Service"
                orderEntities = component "Order Entities" "Order, OrderItem, FulfillmentGroup, etc" "JPA Entities"
                
                # Pricing & Offers
                pricingService = component "Pricing Service" "Cálculo de preços" "Spring Service"
                offerService = component "Offer Service" "Gerenciamento de ofertas/promoções" "Spring Service"
                promotionEngine = component "Promotion Engine" "Motor de regras promocionais" "MVEL"
                
                # Customer
                customerService = component "Customer Service" "Gerenciamento de clientes" "Spring Service"
                customerEntities = component "Customer Entities" "Customer, CustomerAddress, etc" "JPA Entities"
                
                # Checkout & Workflows
                checkoutService = component "Checkout Service" "Orquestração do checkout" "Spring Service"
                workflowEngine = component "Workflow Engine" "Motor de workflows configuráveis" "Spring"
                
                # Payment
                paymentService = component "Payment Service" "Processamento de pagamentos" "Spring Service"
                paymentModuleAPI = component "Payment Module API" "Interface para módulos de pagamento" "Java Interface"
                
                # Fulfillment
                fulfillmentService = component "Fulfillment Service" "Gerenciamento de fulfillment" "Spring Service"
                shippingModuleAPI = component "Shipping Module API" "Interface para módulos de envio" "Java Interface"
                taxModuleAPI = component "Tax Module API" "Interface para cálculo de impostos" "Java Interface"
                
                # CMS
                cmsService = component "CMS Service" "Gerenciamento de conteúdo" "Spring Service"
                pageService = component "Page Service" "Gerenciamento de páginas estáticas" "Spring Service"
                structuredContentService = component "Structured Content Service" "Conteúdo com targeting" "Spring Service"
                
                # Search Integration
                searchService = component "Search Service" "Integração com Solr" "Spring Service"
                solrIndexService = component "Solr Index Service" "Indexação de produtos" "Spring Service"
            }
            
            # Admin Module (projeto Maven admin/)
            adminModule = container "Admin Module" "Módulo administrativo do framework" "Spring MVC, JavaScript" "Framework Module" {
                openAdminPlatform = component "Open Admin Platform" "Plataforma extensível para UIs admin" "Spring MVC"
                adminControllers = component "Admin Controllers" "Controllers base para CRUD" "Spring MVC"
                adminServices = component "Admin Services" "Serviços administrativos" "Spring Service"
                adminSecurity = component "Admin Security" "Segurança e permissões admin" "Spring Security"
                adminAnnotations = component "Admin Presentation Annotations" "Anotações para config de UI" "Java Annotations"
                adminUIComponents = component "Admin UI Components" "Componentes JavaScript/CSS" "JavaScript, CSS"
                adminEntityManagement = component "Entity Management" "Sistema de gerenciamento de entidades" "Spring"
            }
            
            # Common Module (projeto Maven common/)
            commonModule = container "Common Module" "Classes e utilitários compartilhados" "Java, Spring" "Framework Module" {
                extensibilityFramework = component "Extensibility Framework" "Sistema de extensão e herança" "Spring"
                configMerge = component "Configuration Merge" "Merge de configs Spring XML/Java" "Spring"
                qosMonitoring = component "QoS Monitoring" "Monitoramento de qualidade" "JMX"
                cacheSupport = component "Cache Support" "Abstração de cache" "Spring Cache"
                emailSupport = component "Email Support" "Suporte a envio de emails" "Spring Mail"
                webCommon = component "Web Common" "Utilitários web compartilhados" "Spring MVC"
                commonUtilities = component "Common Utilities" "Classes utilitárias gerais" "Java"
                exceptionHandling = component "Exception Handling" "Tratamento de exceções" "Spring"
            }
            
            # Integration Module (projeto Maven integration/)
            integrationModule = container "Integration Module" "Testes de integração do framework" "JUnit, Spring Test" "Test Module" {
                coreTests = component "Core Tests" "Testes dos serviços core" "JUnit"
                adminTests = component "Admin Tests" "Testes das funcionalidades admin" "JUnit"
                workflowTests = component "Workflow Tests" "Testes de workflows" "JUnit"
                testDataFactory = component "Test Data Factory" "Factory de dados de teste" "Java"
            }
        }
        
        # Maven Central (onde o framework é publicado)
        mavenCentral = softwareSystem "Maven Central" "Repositório de artefatos Maven" "External System"
        
        # Relacionamentos entre módulos
        developer -> broadleafFramework "Adiciona como dependência Maven"
        broadleafFramework -> mavenCentral "Publica artefatos"
        
        # Core dependencies
        coreModule -> commonModule "Depende de" "Maven dependency"
        
        # Admin dependencies
        adminModule -> coreModule "Depende de" "Maven dependency"
        adminModule -> commonModule "Depende de" "Maven dependency"
        
        # Integration tests dependencies
        integrationModule -> coreModule "Testa" "JUnit"
        integrationModule -> adminModule "Testa" "JUnit"
        integrationModule -> commonModule "Testa" "JUnit"
        
        # Component relationships - Core
        checkoutService -> workflowEngine "Usa workflows"
        checkoutService -> pricingService "Calcula preços"
        checkoutService -> offerService "Aplica ofertas"
        checkoutService -> promotionEngine "Avalia regras"
        checkoutService -> paymentService "Processa pagamento"
        checkoutService -> fulfillmentService "Calcula frete"
        
        offerService -> promotionEngine "Usa regras MVEL"
        pricingService -> offerService "Aplica ofertas"
        
        paymentService -> paymentModuleAPI "Define interface"
        fulfillmentService -> shippingModuleAPI "Define interface"
        fulfillmentService -> taxModuleAPI "Define interface"
        
        orderService -> workflowEngine "Usa workflows"
        orderService -> orderEntities "Usa"
        catalogService -> catalogEntities "Usa"
        customerService -> customerEntities "Usa"
        
        catalogService -> solrIndexService "Indexa produtos"
        searchService -> solrIndexService "Coordena busca"
        
        # Admin uses Core services
        adminControllers -> catalogService "Gerencia catálogo"
        adminControllers -> orderService "Gerencia pedidos"
        adminControllers -> customerService "Gerencia clientes"
        adminControllers -> cmsService "Gerencia conteúdo"
        adminControllers -> offerService "Gerencia promoções"
        
        openAdminPlatform -> adminAnnotations "Lê configurações"
        openAdminPlatform -> adminEntityManagement "Gerencia entidades"
        adminServices -> adminSecurity "Valida permissões"
        
        # All modules use Common
        catalogService -> extensibilityFramework "Usa extensibilidade"
        orderService -> extensibilityFramework "Usa extensibilidade"
        adminControllers -> webCommon "Usa utilitários web"
        
        # Integration tests
        coreTests -> catalogService "Testa"
        coreTests -> orderService "Testa"
        adminTests -> adminControllers "Testa"
        workflowTests -> workflowEngine "Testa"
    }

    views {
        # System Context - Framework como biblioteca
        systemContext broadleafFramework "FrameworkContext" {
            include *
            autoLayout
        }
        
        # Container Diagram - Módulos Maven
        container broadleafFramework "FrameworkModules" {
            include *
            autoLayout
        }
        
        # Component Diagram - Core Module
        component coreModule "CoreModuleComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Admin Module
        component adminModule "AdminModuleComponents" {
            include *
            autoLayout
        }
        
        # Component Diagram - Common Module
        component commonModule "CommonModuleComponents" {
            include *
            autoLayout
        }
        
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Framework Module" {
                background #2e7d32
                color #ffffff
            }
            element "Test Module" {
                background #f57c00
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
        
        theme default
    }
}

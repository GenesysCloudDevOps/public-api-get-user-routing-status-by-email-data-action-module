resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "properties" = {
            "EmailAddress" = {
                "description" = "Email Address",
                "title" = "Email Address",
                "type" = "string"
            }
        },
        "required" = [
            "EmailAddress"
        ],
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "properties" = {
            "routingStatus" = {
                "description" = "Your agent's routing status",
                "title" = "routingStatus",
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\n   \"expand\": [\"routingStatus\"],\n   \"query\": [\n      {\n         \"fields\": [\"email\"],\n         \"value\": \"$${input.EmailAddress}\",\n         \"operator\": \"AND\",\n         \"type\": \"EXACT\"\n      }\n   ]\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/users/search"
        headers = {
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\r\n   \"routingStatus\": $${list}\r\n  }"
        translation_map = { 
			list = "$.results[0].routingStatus.status"
		}
        translation_map_defaults = {       
			list = "null"
		}
    }
}
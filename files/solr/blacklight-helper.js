/*
  This is a basic skeleton JavaScript update processor.

  In order for this to be executed, it must be properly wired into solrconfig.xml; by default it is commented out in
  the example solrconfig.xml and must be uncommented to be enabled.

  See http://wiki.apache.org/solr/ScriptUpdateProcessor for more details.
*/

function processAdd(cmd) {

  doc = cmd.solrDoc;  // org.apache.solr.common.SolrInputDocument
  id = doc.getFieldValue("id");
  logger.info("update-script#processAdd: id=" + id);
  logger.info("update-script#processAdd: keys=" + doc.keySet());

  // Set PCDM Type based on rdf_type and member type
  pcdm_collection = "http://pcdm.org/models#Collection";
  pcdm_object = "http://pcdm.org/models#Object"; 
  pcdm_file = "http://pcdm.org/models#File";

  pcdm_key = "pcdm_has_member";
  rdf_key = "rdf_type";
  pcdm_has_member_val = null;
  rdf_type_object_val = null;

  if (doc.containsKey(pcdm_key)) { 
    pcdm_has_member_val = doc.getFieldValues(pcdm_key);
  }
  if (doc.containsKey(rdf_key)) { 
    rdf_type_object_val = doc.getFieldValues(rdf_key);
  }

  type = "";
  if (rdf_type_object_val != null) {
    types = rdf_type_object_val.toArray();
    for(i=0; i < types.length; i++) {
      if (types[i] == pcdm_collection) {
        type = "COLLECTION";
        break;
      } else if (types[i] == pcdm_object) {
        type = "OBJECT"
        if (pcdm_has_member_val != null) {
          if (typeof pcdm_has_member_val == "string") {
            members = [].concat(pcdm_has_member_val);
          } else {
            members = pcdm_has_member_val.toArray();
          }
          if (members.length > 0) {
            first_member = members[0];
            if (first_member.startsWith(id + "/files")) {
              // This is a file proxy. Leave the type blank.
              type = "";
            }
          }
        }
        break;
      } else if (types[i] == pcdm_file) {
        type = "FILE";
        break;
      }
    }
    if (type != null) {
      doc.setField("pcdm_type", type);
    }
  }
  // Remove pcdm has members field
  doc.remove(pcdm_key);
}

function processDelete(cmd) {
  // no-op
}

function processMergeIndexes(cmd) {
  // no-op
}

function processCommit(cmd) {
  // no-op
}

function processRollback(cmd) {
  // no-op
}

function finish() {
  // no-op
}

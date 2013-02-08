defineSeed(2381, 1, makeCastMap([Q$RunAsyncCallback]));
_.onFailure = function onFailure_164(reason){
}
;
_.onSuccess = function onSuccess_164(){
  var node;
  node = $findById(getOrCreateRef_13($getAttributeAsJavaScriptObject_1(this.this$0, 'data')), this.val$finalKey);
  if (node) {
    $deselectAllRecords(this.this$0);
    $selectRecord(this.this$0, node);
  }
}
;
_.this$0 = null;
_.val$finalKey = null;
var Lorg_rhq_enterprise_gui_coregui_client_content_repository_tree_ContentRepositoryTreeView$2_2_classLit = createForClass('org.rhq.enterprise.gui.coregui.client.content.repository.tree.', 'ContentRepositoryTreeView$2', 2381);
$entry(onLoad_1)(1);

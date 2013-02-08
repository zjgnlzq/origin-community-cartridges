defineSeed(2124, 1, makeCastMap([Q$RunAsyncCallback]));
_.onSuccess = function onSuccess_154(){
  var node;
  node = $findById(getOrCreateRef_13($getAttributeAsJavaScriptObject_1(this.this$0, 'data')), this.val$finalKey);
  if (node) {
    $deselectAllRecords(this.this$0);
    $selectRecord(this.this$0, node);
  }
}
;
$entry(onLoad_1)(2);

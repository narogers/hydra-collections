# View Helpers for Hydra Batch Edit functionality
module CollectionsHelper 
  
 
  # Displays the Collections create collection button.  Put this in your search result page template.  We recommend putting it in catalog/_sort_and_per_page.html.erb
  def button_for_create_collection(label = 'Create Collection')
    render partial:'/collections/button_create_collection', locals:{label:label}
  end

  # Displays the Collections update collection button.  Put this in your search result page template.  We recommend putting it in catalog/_sort_and_per_page.html.erb
  def button_for_update_collection(label = 'Update Collection', collection_id = 'collection_replace_id' )
    render partial:'/collections/button_for_update_collection', locals:{label:label, collection_id:collection_id}
  end
  
  # Displays the Collections delete collection button.  Put this in your search result page for each collection found.
  def button_for_delete_collection(collection, label = 'Delete Collection' )
    render partial:'/collections/button_for_delete_collection', locals:{collection:collection,label:label}
  end

  def button_for_remove_from_collection(document, label = 'Remove From Collection')
    render partial:'/collections/button_remove_from_collection', locals:{label:label, document:document}
  end

  # add hidden fields to a form for removing a single document from a collection
  def single_item_action_remove_form_fields(form, document)
    single_item_action_form_fields(form, document, "remove")
  end
  
  # add hidden fields to a form for adding a single document to a collection
  def single_item_action_add_form_fields(form, document)
    single_item_action_form_fields(form, document, "add")
  end

  # add hidden fields to a form for performing an action on a single document on a collection      
  def single_item_action_form_fields(form, document, action)
    render partial:'/collections/single_item_action_fields', locals:{form:form, document:document, action: action}
  end
  
end

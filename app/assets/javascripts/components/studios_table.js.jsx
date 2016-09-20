var StudiosTable = React.createClass({
	getInitialState: function(){
		return {
			studios: this.props.studios,
			year: $('meta[description="alice-year"]').attr('content'),
		}
	},
	updateParents: function(studios_){
		this.props.handleStudios(studios_);
		this.setState(this.getInitialState());
	},
	render: function() {
		var that = this;
		var studioRow = function(studio){
			var currentUser = that.context.currentUser;
			var canEdit = (currentUser.admin || currentUser.studio && studio.id == currentUser.studio.id);
			var name, tag_list, action;

			if(!canEdit){
				name = <td>{studio.name}</td>;
				tag_list = <td>{studio.tag_list}</td>;
			}
			else{
				var destroyStudio = function(){
					$.ajax({
						url: '/years/'+ that.state.year + '/studios/'+studio.id,
						method: 'delete',
						success: function(res){
					    var index = that.state.studios.indexOf(studio);
							var studios_ = React.addons.update(that.state.studios, { $splice: [[index, 1]] })
							that.updateParents(studios_);
						},
					});
				};
				var toggleEditable = function(){
					var editable;
					if(!studio.editable)
					{
						studio.originalName = studio.name;
					}
					else{
						studio.name = studio.originalName;
					}
					var studios_ = that.state.studios.map(function(s){
						s.editable = s === studio ? !s.editabe : false;
						return s;
					});
					that.setState({
						studios: studios_,
						editable: editable
					});
				};
				var handleKey = function(e){
					if(e.keyCode == '27')
					{
						toggleEditable();
					}
					else if(e.keyCode == '13')
					{
						submitChange();
					}
					else
					{
						studio[e.target.attributes.name.value] = e.target.value;
						console.log(studio, e.target.name, e.target.value);
					}
				};

				var submitChange = function(){
					$.ajax({
						url: '/years/'+ that.state.year + '/studios/' + studio.id,
						method: 'PUT',
						data: {
							studio:{
								name: studio.name,
								tag_list: studio.tag_list
							}
						},
						success: function(data){
							var index = that.state.studios.indexOf(studio);
							var studios_ = React.addons.update(that.state.studios, { $splice: [[index, 1, data]] });
							that.updateParents(studios_);
						},
						error: function(e){
							alert('Error editing the studio')
						}
					})
				};
				if(studio.editable)
				{
					name = <td><input className="field" type="text" name="name" defaultValue={studio.name} onKeyUp={handleKey}/></td>;
					tag_list = <td><input className="field" type="text" name="tag_list" defaultValue={studio.tag_list} onKeyUp={handleKey}/></td>;
					action = <span><button className="ui button basic green mini" onClick={submitChange}> Save </button><button className="ui button red basic mini" onClick={destroyStudio}> Delete </button></span>
				}
				else
				{
					name = <td onDoubleClick={toggleEditable}>{studio.name}</td>
					tag_list = <td onDoubleClick={toggleEditable}>{studio.tag_list}</td>
					action = <button className="ui button basic mini" onClick={toggleEditable}> Edit </button>
				}
			}


			return (<tr key={studio.name} className="ui fields form">
						{name}
						{tag_list}
						<td>
							{action}
						</td>
					</tr>);
		};
		var form = that.context.currentUser.admin ? <StudioForm handleNewStudio={this.props.handleNewStudio} /> : null
		return <div>
				<table className="ui table compact striped ">
					<tbody>
						<tr className="ui">
							<td>Name</td>
							<td>Tags</td>
							<td></td>
						</tr>
						{this.props.studios.map(function(s){
							return studioRow(s);
						})}
						{form}
					</tbody>
				</table>
			</div>;
	}
});
StudiosTable.contextTypes = {
  currentUser: React.PropTypes.any
};

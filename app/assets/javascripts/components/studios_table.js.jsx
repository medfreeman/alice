var StudiosTable = React.createClass({
	getInitialState: function(){
		return {
			studios: this.props.studios
		}
	},
	render: function() {
		var that = this;
		var studioRow = function(studio){
			var toggleEditable = function(){
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
					studios: studios_
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
					studio.name = e.target.value;
				}
			};

			var submitChange = function(){
				$.ajax({
					url: '/studios/'+studio.id,
					method: 'PUT',
					data: {
						studio:{
							name: studio.name,
						}
					},
					success: function(data){
						var index = that.state.studios.indexOf(studio);
						var studios_ = React.addons.update(that.state.studios, { $splice: [[index, 1, data]] });
						that.props.handleStudios(studios_);
						that.setState(that.getInitialState());
					},
					error: function(e){
						alert('Error editing the studio')
					}
				})
			};
			var name, action;
			if(studio.editable)
			{
				name = <div className="field"><input type="text" defaultValue={studio.name} onKeyUp={handleKey}/></div>;
				action = <button className="ui button basic green" onClick={submitChange}> Save </button>
			}
			else
			{
				name = <div onDoubleClick={toggleEditable}>{studio.name}</div>
				action = <button className="ui button basic" onClick={toggleEditable}> Edit </button>
			}

			return <div className={studio.editable ? 'ui form' : null}>
				{name}
				{action}
			</div>;
		};
		return <div>
			{this.state.studios.map(function(s){
				return studioRow(s);
			})}
		</div>;
	}
});

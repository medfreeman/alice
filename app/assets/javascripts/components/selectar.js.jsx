var Selectar = React.createClass({
	getInitialState: function(){
		return {
			name: this.props.name,
			options: this.props.options,
			value: this.props.value
		};
	},
	handleChange: function(e){
		var val = e.target.value;
		if(val != 'empty')
		{
			this.setState({
				value: val,
			});
			this.props.handleChange(e, this.state.name, val);
		}
	},
	render: function(){
		var emptyOption = this.props.allowEmpty ? <option value="empty"/> : null;
		return (
			<select name={this.state.name} value={this.state.value} onChange={this.handleChange}>
			{emptyOption}
				{
					this.state.options.map(function(option){
						if(typeof option == 'string')
						{
				  		return <option key={option} value={option}>{option}</option>;
						}
						else
						{
							return <option key={option[0]} value={option[0]}>{option[1]}</option>;
						}
					})
				}
			</select>
		);
	}
});
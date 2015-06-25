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
		this.setState({
			value: val,
		});
		this.props.handleChange(e, this.state.name, val);
	},
	render: function(){
		return (
			<select name={this.state.name} value={this.state.value} onChange={this.handleChange}>
				{
					this.state.options.map(function(option){
				  	return <option key={option} value={option}>{option}</option>;
					})
				}
			</select>
		);
	}
});
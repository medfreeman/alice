var User = React.createClass({
  propTypes: {
    role: React.PropTypes.string,
    name: React.PropTypes.string,
    sciper: React.PropTypes.string,
    email: React.PropTypes.string,
    studio: React.PropTypes.string
  },

  render: function() {
    return (
      <tr>
        <td>{this.props.user.sciper}</td>
        <td>{this.props.user.name}</td>
        <td>{this.props.user.email}</td>
        <td>{this.props.user.role}</td>
        <td>{this.props.user.studio}</td>
      </tr>
    );
  }
});
